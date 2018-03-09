require 'snakes'

require_relative '../server_game'

module SnakesAPI
  module Factories
    module ServerGameFactory
      class << self
        def one_player_game(client, game_id)
          game = Snakes.standard_game([])
          ServerGame.new(game, game_id).tap do |server_game|
            server_game.add_client(client)
          end
        end
      end
    end
  end
end
