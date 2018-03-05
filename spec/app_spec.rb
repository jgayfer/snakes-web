require 'app'
require 'server_game'
require 'snakes'

require_relative 'mocks/mock_store'

describe 'Snakes API routes' do
  include Rack::Test::Methods

  let(:game_id) { 'game-id' }
  let(:client_id) { 'client-id' }
  let(:game) { Snakes.standard_game(['player1']) }
  let(:server_game) { ServerGame.new(game, game_id) }
  let(:client) { Client.new(Snakes::Player.new('player1'), client_id) }
  before { server_game.add_client(client) }

  def app
    App.tap { |app| app.opts[:db] = MockStore.new(server_game) }
  end

  it 'creates a new game' do
    post '/game/?player=name1'
    expect(last_response).to be_ok
  end

  it 'retrieves an existing game' do
    get "/game/#{game_id}/?client_id=#{client_id}"
    expect(last_response).to be_ok
  end

  it 'moves the next player in a game' do
    post "/game/#{game_id}/move/?client_id=#{client_id}"
    expect(last_response).to be_ok
  end

  it 'returns an error if no game exists' do
    get '/game/fake-id'
    expect(last_response.body).to eq('Game not found')
  end

  it 'returns an error if no client id match' do
    get "/game/#{game_id}/?client_id=fake"
    expect(last_response.body).to eq('Not your turn!')
  end

  it 'returns an error if no client id is given' do
    get "/game/#{game_id}"
    expect(last_response.body).to eq('No client id provided')
  end

  it 'returns an error if no player is given' do
    post '/game/'
    expect(last_response.body).to eq('No player provided')
  end
end
