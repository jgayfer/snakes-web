require 'json'

RSpec.describe SnakesAPI::ResponseFormatter do
  let(:game) { Snakes.standard_game(%w['pants shirt']) }
  let(:server_game) { SnakesAPI::ServerGame.new(game, 'fake-id') }
  let(:client_id) { 'client-id' }

  describe '.format_game' do
    context 'client id is given' do
      subject { JSON.parse(SnakesAPI::ResponseFormatter.format_game(server_game, client_id)) }
      it 'has the correct keys' do
        expect(subject).to have_key('game_id')
        expect(subject).to have_key('game')
        expect(subject).to have_key('client_id')
        expect(subject).to have_key('game_has_started')
      end
    end

    context 'client id is not given' do
      subject { JSON.parse(SnakesAPI::ResponseFormatter.format_game(server_game)) }
      it 'has the correct keys' do
        expect(subject).to have_key('game_id')
        expect(subject).to have_key('game')
        expect(subject).not_to have_key('client_id')
        expect(subject).to have_key('game_has_started')
      end
    end
  end
end
