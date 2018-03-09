module SnakesAPI
  # This class represents a connected client
  class Client
    attr_reader :id, :player

    def initialize(player, id)
      @player = player
      @id = id
    end
  end
end
