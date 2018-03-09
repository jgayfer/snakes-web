module SnakesAPI
  module Responses
    # An HTTP response body containing a game
    class GameResponse
      def initialize(server_game)
        @server_game = server_game
      end

      def to_s
        response = {}
        response['game'] = JSON.parse(Snakes::JSONFormatter.new(@server_game.game).game_json)
        response['game_has_started'] = @server_game.game_has_started
        JSON.generate(response)
      end
    end
  end
end
