RSpec.describe SnakesAPI::Responses::GameResponse do
  let(:player) { Snakes::Player.new('pants') }
  let(:client) { SnakesAPI::Client.new(player, 'fake-id') }
  let(:server_game) do
    SnakesAPI::Factories::ServerGameFactory.one_player_game(client, 'fake-id')
  end
  let(:game_response) { described_class.new(server_game) }

  describe '#initialize' do
    subject { game_response }
    it { is_expected.to be_a described_class }
  end

  describe '#to_s' do
    subject { game_response.to_s }
    it 'returns a json/text representation of server_game' do
      expect(subject).to eq(fixture('game_response.json').chomp)
    end
  end
end
