require 'app'
require 'server_game'
require 'snakes'

require_relative 'mocks/mock_store'

describe 'Snakes API routes' do
  include Rack::Test::Methods

  let(:id) { 'real-id' }
  let(:game) { Snakes.standard_game(['player1']) }
  let(:server_game) { ServerGame.new(game, id) }

  def app
    App.tap { |app| app.opts[:db] = MockStore.new(server_game) }
  end

  it 'creates a new game' do
    post '/game/?player=name1'
    expect(last_response).to be_ok
  end

  it 'retrieves an existing game' do
    get "/game/#{id}"
    expect(last_response).to be_ok
  end

  it 'moves the next player in a game' do
    post "/game/#{id}/move"
    expect(last_response).to be_ok
  end

  it 'returns an error message if no game exists' do
    get '/game/fake-id'
    expect(last_response.body).to eq('Game not found')
  end
end
