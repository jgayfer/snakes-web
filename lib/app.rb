require 'bundler/setup'
require 'snakes'
require 'roda'
require 'securerandom'

require_relative 'response_formatter'

# Routing class for the snakes and ladders API
class App < Roda
  plugin :all_verbs
  plugin :default_headers,
         'Access-Control-Allow-Origin' => '*'

  route do |r|
    r.on 'game' do
      r.on String do |id|
        game = find_game(id)

        # GET /game/{id}
        r.get do
          ResponseFormatter.format_game(game, id)
        end

        # POST /game/{id}/move
        r.is 'move' do
          r.post do
            game.move_next_player
            save_game(game, id)
            ResponseFormatter.format_game(game, id)
          end
        end
      end

      # POST /game
      # Create a new game
      r.post do
        player_names = r.params['players'].split(',')
        new_game = Snakes.standard_game(player_names)
        id = SecureRandom.uuid
        save_game(new_game, id)
        ResponseFormatter.format_game(new_game, id)
      end
    end
  end

  def save_game(game, id)
    store = opts[:db]
    store.transaction do
      store[id] = game
      store.commit
    end
  end

  def find_game(id)
    store = opts[:db]
    store.transaction { store[id] }
  end
end
