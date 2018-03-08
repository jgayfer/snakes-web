require 'response_formatter'
require 'server_game'
require 'snakes'
require 'json'

RSpec.describe ResponseFormatter do
  let(:game) { Snakes.standard_game(%w['pants shirt']) }
  let(:server_game) { ServerGame.new(game, 'fake-id') }
  let(:client_id) { 'client-id' }

  describe '.format_game' do
    subject { JSON.parse(ResponseFormatter.format_game(server_game, client_id)) }

    it 'has the correct keys' do
      expect(subject).to have_key('game_id')
      expect(subject).to have_key('game')
      expect(subject).to have_key('client_id')
      expect(subject).to have_key('game_has_started')
    end
  end
end
