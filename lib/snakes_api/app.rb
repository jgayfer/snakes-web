module SnakesAPI
  # Routing class for the snakes and ladders API
  class App < Roda
    plugin :all_verbs
    plugin :error_handler, &:message
    plugin :default_headers,
          'Access-Control-Allow-Origin' => '*'

    route do |r|
      r.on 'game' do
        player_name = r.params['player']

        r.on String do |game_id|
          server_game = find_server_game(game_id)
          client_id = r.params['client_id']

          # Error checking
          game_not_found_response(r) unless server_game

          # POST /game/{id}/join
          r.on 'join' do
            r.post do
              invalid_parameters_response(r) unless player_name
              client_id = opts[:generate_client_id].call
              client = Client.new(Snakes::Player.new(player_name), client_id)
              server_game.add_client(client)
              save_server_game(server_game)
              Responses::CredentialsResponse.new(game_id, client_id).to_s
            end
          end

          # GET /game/{id}
          r.get do
            Responses::GameResponse.new(server_game).to_s
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
              '{}'
            end
          end

          # POST /game/{id}/start
          r.on 'start' do
            r.post do
              server_game.start_game
              save_server_game(server_game)
              '{}'
            end
          end
        end

        # POST /game
        r.post do
          invalid_parameters_response(r) unless player_name
          client_id = opts[:generate_client_id].call
          game_id = opts[:generate_game_id].call
          client = Client.new(Snakes::Player.new(player_name), client_id)
          server_game = Factories::ServerGameFactory.one_player_game(client, game_id)
          save_server_game(server_game)
          Responses::CredentialsResponse.new(game_id, client_id).to_s
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
  end
end
