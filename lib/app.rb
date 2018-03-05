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
      r.on String do |id|
        server_game = find_server_game(id)
        client_id = r.params['client_id']

        # Error checking
        raise StandardError, 'Game not found' unless server_game
        unless server_game.client_id_in_game?(client_id)
          raise StandardError, 'Invalid client id'
        end

        # GET /game/{id}
        r.get do
          ResponseFormatter.format_game(server_game, client_id)
        end

        # POST /game/{id}/move
        r.on 'move' do
          r.post do
            server_game.game.move_next_player
            save_server_game(server_game)
            ResponseFormatter.format_game(server_game, client_id)
          end
        end
      end

      # POST /game
      # Create a new game
      r.post do
        raise StandardError, 'No player provided' unless r.params['player']
        client_id = SecureRandom.uuid
        server_game = server_game_factory(r.params['player'], client_id)
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
