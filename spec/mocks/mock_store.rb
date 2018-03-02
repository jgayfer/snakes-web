require 'snakes'

class MockStore
  def initialize; end

  def transaction
    yield
    Snakes.standard_game(%w['shirt pants'])
  end

  def []=(_, _); end

  def [](_); end

  def commit; end
end
