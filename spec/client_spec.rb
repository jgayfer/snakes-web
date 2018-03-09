RSpec.describe SnakesAPI::Client do
  let(:player) { Snakes::Player.new('dummy') }
  let(:client) { SnakesAPI::Client.new(player, 'abc123') }

  describe '#initialize' do
    subject { client }
    it { is_expected.to be_a SnakesAPI::Client }
  end
end
