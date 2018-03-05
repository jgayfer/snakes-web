require 'snakes'
require 'server_game'

# This class mocks a PStore database connection
class MockStore
  def initialize; end

  def transaction
    yield
    ServerGame.new(Snakes.standard_game(%w['shirt pants']), 'fake-id')
  end

  def []=(_, _); end

  def [](_); end

  def commit; end
end
