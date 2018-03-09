require 'snakes'
require 'json'

module SnakesAPI
  # This class is responsible for forming the JSON responses
  class ResponseFormatter
    class << self
      def format_game(server_game, client_id = nil)
        response = {}
        response['game_id'] = server_game.id
        response['client_id'] = client_id if client_id
        response['game'] = JSON.parse(game_json(server_game.game))
        response['game_has_started'] = server_game.game_has_started
        JSON.generate(response)
      end

      private

      def game_json(game)
        json_formatter = Snakes::JSONFormatter.new(game)
        json_formatter.game_json
      end
    end
  end
end
