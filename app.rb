require 'snakes'
require 'roda'
require 'pstore'
require 'json'

require_relative 'response_formatter'

class App < Roda
  plugin :all_verbs
  plugin :error_handler do |e|
    "Error: #{e.message}"
  end

  route do |r|
    r.on 'game' do
      r.on Integer do |id|
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
        new_game = Snakes.standard_game(JSON.parse(r.params['players']))
        id = rand(100000)
        save_game(new_game, id)
        ResponseFormatter.format_game(new_game, id)
      end
    end
  end

  def save_game(game, id)
    store = db
    store.transaction do
      store[id] = game
      store.commit
    end
  end

  def find_game(id)
    store = db
    store.transaction { store[id] }
  end

  def db
    PStore.new('my_database.pstore')
  end
end
