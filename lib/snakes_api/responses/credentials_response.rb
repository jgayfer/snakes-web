module SnakesAPI
  module Responses
    # An HTTP response body containing credentials needed to play game
    class CredentialsResponse
      def initialize(game_id, client_id)
        @game_id = game_id
        @client_id = client_id
      end

      def to_s
        response = {}
        response['game_id'] = @game_id
        response['client_id'] = @client_id
        JSON.generate(response)
      end
    end
  end
end
