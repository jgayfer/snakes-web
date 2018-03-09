require 'securerandom'

module SnakesAPI
  # This module is responsible for generating client and game IDs
  module GenerateID
    class << self
      def call
        SecureRandom.uuid
      end
    end
  end
end
