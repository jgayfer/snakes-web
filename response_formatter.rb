require 'snakes'
require 'json'

class ResponseFormatter
  class << self
    def format_game(game, id)
      response = {}
      response['id'] = id
      response['game'] = JSON.parse(game_json(game))
      JSON.generate(response)
    end

    private

    def game_json(game)
      json_formatter = Snakes::JSONFormatter.new(game)
      json_formatter.game_json
    end
  end
end
