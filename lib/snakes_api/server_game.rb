module SnakesAPI
  # This class represents a game and the clients connected to it
  class ServerGame
    attr_reader :clients, :id, :game, :game_has_started

    def initialize(game, id)
      @clients = []
      @game = game
      @id = id
      @game_has_started = false
    end

    def add_client(client)
      @clients << client
      @game.add_player(client.player)
    end

    def client_id_in_game?(client_id)
      find_client(client_id)
    end

    def client_id_is_next_player?(client_id)
      client = find_client(client_id)
      @game.next_player == client.player
    end

    def start_game
      @game_has_started = true
    end

    private

    def find_client(id)
      @clients.find { |client| client.id == id }
    end
  end
end
