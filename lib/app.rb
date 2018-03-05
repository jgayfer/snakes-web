require 'bundler/setup'
require 'snakes'
require 'roda'
require 'securerandom'

require_relative 'response_formatter'
require_relative 'server_game'

# Routing class for the snakes and ladders API
class App < Roda
  plugin :all_verbs
  plugin :error_handler, &:message
  plugin :default_headers,
         'Access-Control-Allow-Origin' => '*'

  route do |r|
    r.on 'game' do
      r.on String do |id|
        server_game = find(id)

        # Error checking
        raise StandardError, 'Game not found' unless server_game
        unless server_game.client_id_in_game?(r.params['client_id'])
          raise StandardError, 'Invalid client id'
        end

        # GET /game/{id}
        r.get do
          ResponseFormatter.format_game(server_game)
        end

        # POST /game/{id}/move
        r.is 'move' do
          r.post do
            server_game.game.move_next_player
            save(server_game)
            ResponseFormatter.format_game(server_game)
          end
        end
      end

      # POST /game
      # Create a new game
      r.post do
        player_name = r.params['player']
        game = Snakes.standard_game([player_name])
        server_game = ServerGame.new(game, SecureRandom.uuid)
        save(server_game)
        ResponseFormatter.format_game(server_game)
      end
    end
  end

  def save(server_game)
    store = opts[:db]
    store.transaction do
      store[server_game.id] = server_game
      store.commit
    end
  end

  def find(id)
    store = opts[:db]
    store.transaction { store[id] }
  end
end
