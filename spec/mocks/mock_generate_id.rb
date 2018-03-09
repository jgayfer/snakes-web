class MockGenerateID
  def initialize(id)
    @id = id
  end

  def call
    @id
  end
end
