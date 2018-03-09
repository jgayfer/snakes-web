# This class mocks a PStore database connection
class MockStore
  def initialize(server_game)
    @server_game = server_game
  end

  def transaction
    yield
  end

  def []=(_, _); end

  def [](id)
    @server_game if id == @server_game.id
  end

  def commit; end
end
