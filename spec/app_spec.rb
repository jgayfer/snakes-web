require 'app'
require 'server_game'
require 'snakes'

require_relative 'mocks/mock_store'

describe 'Snakes API routes' do
  include Rack::Test::Methods

  let(:game_id) { 'game-id' }
  let(:client1_id) { 'client1-id' }
  let(:client2_id) { 'client2-id' }
  let(:game) { Snakes.standard_game([]) }
  let(:server_game) { ServerGame.new(game, game_id) }
  let(:client1) { Client.new(Snakes::Player.new('player1'), client1_id) }
  let(:client2) { Client.new(Snakes::Player.new('player2'), client2_id) }
  before { server_game.add_client(client1) }
  before { server_game.add_client(client2) }

  def app
    App.tap { |app| app.opts[:db] = MockStore.new(server_game) }
  end

  it 'creates a new game' do
    post '/game/?player=name1'
    expect(last_response).to be_ok
  end

  it 'retrieves an existing game' do
    get "/game/#{game_id}/?client_id=#{client1_id}"
    expect(last_response).to be_ok
  end

  it 'joins an existing game' do
    post "/game/#{game_id}/join/?player=someone"
    expect(last_response).to be_ok
  end

  it 'moves the next player in a game' do
    post "/game/#{game_id}/move/?client_id=#{client1_id}"
    expect(last_response).to be_ok
  end

  it "doesn't move player when not their turn" do
    post "/game/#{game_id}/move/?client_id=#{client1_id}"
    post "/game/#{game_id}/move/?client_id=#{client1_id}"
    expect(last_response.body).to eq("It's not your turn")
  end

  it 'returns an error if no game exists' do
    get '/game/fake-id'
    expect(last_response.body).to eq('Game not found')
  end

  it 'returns an error if not part of game' do
    get "/game/#{game_id}/?client_id=fake"
    expect(last_response.body).to eq("You aren't part of this game")
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
