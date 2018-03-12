module SnakesAPI
  module Responses
    # An HTTP response for an empty body
    class EmptyResponse
      def initialize; end

      def to_s
        '{}'
      end
    end
  end
end
