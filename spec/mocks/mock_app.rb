require 'app'
require 'snakes'

class MockApp < App
  def find_game(_)
    Snakes.standard_game(%w['shirt pants'])
  end

  def save_game(_, _); end
end
