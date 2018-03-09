RSpec.describe SnakesAPI::Factories::ServerGameFactory do
  let(:client) { SnakesAPI::Client.new(Snakes::Player.new('pants'), 'fake-id') }

  describe '.one_player_game' do
    subject { SnakesAPI::Factories::ServerGameFactory.one_player_game(client, 'fake-id') }
    it { is_expected.to be_a SnakesAPI::ServerGame }

    it 'includes the client' do
      expect(subject.clients.first).to be client
    end
  end
end
