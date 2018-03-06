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
        raise StandardError, 'Game not found' unless server_game

        # POST /game/{id}/join
        r.on 'join' do
          r.post do
            raise StandardError, 'No player provided' unless player_name
            player = Snakes::Player.new(player_name)
            client = Client.new(player, SecureRandom.uuid)
            server_game.add_client(client)
            save_server_game(server_game)
            ResponseFormatter.format_game(server_game, client.id)
          end
        end

        # Error checking
        raise StandardError, 'No client id provided' unless client_id
        unless server_game.client_id_in_game?(client_id)
          raise StandardError, "You aren't part of this game"
        end

        # GET /game/{id}
        r.get do
          ResponseFormatter.format_game(server_game, client_id)
        end

        # POST /game/{id}/move
        r.on 'move' do
          r.post do
            unless server_game.client_id_is_next_player?(client_id)
              raise StandardError, "It's not your turn"
            end
            server_game.game.move_next_player
            save_server_game(server_game)
            ResponseFormatter.format_game(server_game, client_id)
          end
        end
      end

      # POST /game
      # Create a new game
      r.post do
        raise StandardError, 'No player provided' unless player_name
        client_id = SecureRandom.uuid
        server_game = server_game_factory(player_name, client_id)
        save_server_game(server_game)
        ResponseFormatter.format_game(server_game, client_id)
      end
    end
  end

  private

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
    game = Snakes.standard_game([player_name])
    server_game = ServerGame.new(game, SecureRandom.uuid)
    client = Client.new(Snakes::Player.new(player_name), client_id)
    server_game.add_client(client)
    server_game
  end
end
