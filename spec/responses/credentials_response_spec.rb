RSpec.describe SnakesAPI::Responses::CredentialsResponse do
  let(:game_response) { described_class.new('game-id', 'client-id') }

  describe '#initialize' do
    subject { game_response }
    it { is_expected.to be_a described_class }
  end

  describe '#to_s' do
    subject { game_response.to_s }
    it 'returns a json/text representation of the credentials' do
      expect(subject).to eq(fixture('credentials_response.json').chomp)
    end
  end
end
