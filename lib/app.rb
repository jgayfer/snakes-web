require 'bundler/setup'
require 'snakes'
require 'roda'
require 'securerandom'

require_relative 'response_formatter'
require_relative 'server_game'
require_relative 'client'

# Routing class for the snakes and ladders API
class App < Roda
  plugin :all_verbs
  plugin :error_handler, &:message
  plugin :default_headers,
         'Access-Control-Allow-Origin' => '*'

  route do |r|
    r.on 'game' do
      player_name = r.params['player']

      r.on String do |id|
        server_game = find_server_game(id)
        client_id = r.params['client_id']

        # Error checking
        game_not_found_response(r) unless server_game

        # POST /game/{id}/join
        r.on 'join' do
          r.post do
            invalid_parameters_response(r) unless player_name
            player = Snakes::Player.new(player_name)
            client = Client.new(player, SecureRandom.uuid)
            server_game.add_client(client)
            save_server_game(server_game)
            ResponseFormatter.format_game(server_game, client.id)
          end
        end

        # GET /game/{id}
        r.get do
          ResponseFormatter.format_game(server_game, client_id)
        end

        # Error checking
        invalid_parameters_response(r) unless client_id
        unless server_game.client_id_in_game?(client_id)
          client_not_in_game_response(r)
        end

        # POST /game/{id}/move
        r.on 'move' do
          r.post do
            unless server_game.client_id_is_next_player?(client_id)
              not_client_turn_response(r)
            end
            server_game.game.move_next_player
            save_server_game(server_game)
            ResponseFormatter.format_game(server_game, client_id)
          end
        end

        # POST /game/{id}/start
        r.on 'start' do
          r.post do
            server_game.start_game
            save_server_game(server_game)
            ResponseFormatter.format_game(server_game, client_id)
          end
        end
      end

      # POST /game
      # Create a new game
      r.post do
        invalid_parameters_response(r) unless player_name
        client_id = SecureRandom.uuid
        server_game = server_game_factory(player_name, client_id)
        save_server_game(server_game)
        ResponseFormatter.format_game(server_game, client_id)
      end
    end
  end

  private

  def game_not_found_response(r)
    response.status = 404
    response.write('Game not found')
    r.halt
  end

  def invalid_parameters_response(r)
    response.status = 422
    response.write('Invalid parameters')
    r.halt
  end

  def client_not_in_game_response(r)
    response.status = 403
    response.write('Given client is not part of this game')
    r.halt
  end

  def not_client_turn_response(r)
    response.status = 403
    response.write("It's not your turn")
    r.halt
  end

  def save_server_game(server_game)
    store = opts[:db]
    store.transaction do
      store[server_game.id] = server_game
      store.commit
    end
  end

  def find_server_game(id)
    store = opts[:db]
    store.transaction { store[id] }
  end

  def server_game_factory(player_name, client_id)
    game = Snakes.standard_game([])
    server_game = ServerGame.new(game, SecureRandom.uuid)
    client = Client.new(Snakes::Player.new(player_name), client_id)
    server_game.add_client(client)
    server_game
  end
end
