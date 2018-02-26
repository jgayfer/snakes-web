require 'snakes'
require 'roda'
require 'pstore'

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
          'get' # game json
        end

        # POST /game/{id}/move
        r.is 'move' do
          r.post do
            game.move_next_player if r.params['move_next_player']
            save_game(game)
            'put' # game json
          end
        end
      end

      # POST /game
      r.post do
        new_game = Snakes.standard_game(r.params['players'].split(','))
        save_game(new_game)
        'post' # game json
      end
    end
  end

  def save_game(game)
    store = db
    store.transaction do
      store[game.object_id] = game
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
