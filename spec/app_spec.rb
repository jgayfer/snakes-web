require 'app'

require_relative 'mocks/mock_store'

describe 'Snakes API routes' do
  include Rack::Test::Methods

  def app
    App.tap { |app| app.opts[:db] = MockStore.new }
  end

  it 'creates a new game' do
    post '/game/?player=name1'
    expect(last_response).to be_ok
  end

  it 'retrieves an existing game' do
    get '/game/fake-id'
    expect(last_response).to be_ok
  end

  it 'moves the next player in a game' do
    post '/game/fake-id/move'
    expect(last_response).to be_ok
  end
end
