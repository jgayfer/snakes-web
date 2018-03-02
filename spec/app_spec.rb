require 'app'
require 'json'

require_relative 'mocks/mock_store'

describe 'Snakes API routes' do
  include Rack::Test::Methods

  let(:id) { 'fake-id' }

  def app
    App.opts[:db] = MockStore.new
    App
  end

  it 'creates a new game' do
    post '/game/?players=name1,name2'

    expect(last_response).to be_ok
  end

  it 'retrieves an existing game' do
    get "/game/#{id}"

    json = JSON.parse(last_response.body)

    expect(last_response).to be_ok
    expect(json['id']).to match id
  end

  it 'moves the next player in a game' do
    post "/game/#{id}/move"

    expect(last_response).to be_ok
  end
end
