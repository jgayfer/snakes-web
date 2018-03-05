require 'response_formatter'
require 'server_game'
require 'snakes'
require 'json'

RSpec.describe ResponseFormatter do
  let(:game) { Snakes.standard_game(%w['pants shirt']) }
  let(:server_game) { ServerGame.new(game, 'fake-id') }

  describe '.format_game' do
    subject { JSON.parse(ResponseFormatter.format_game(server_game)) }

    it 'has the correct keys' do
      expect(subject).to have_key('id')
      expect(subject).to have_key('game')
    end
  end
end
