require 'response_formatter'
require 'snakes'
require 'json'

RSpec.describe ResponseFormatter do
  let(:game) { Snakes.standard_game(%w['pants shirt']) }
  let(:id) { 'fake-id' }

  describe '.format_game' do
    subject { JSON.parse(ResponseFormatter.format_game(game, id)) }

    it 'has the correct keys' do
      expect(subject).to have_key('id')
      expect(subject).to have_key('game')
    end
  end
end
