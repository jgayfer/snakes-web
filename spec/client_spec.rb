require 'client'
require 'snakes'

RSpec.describe Client do
  let(:player) { Snakes::Player.new('dummy') }
  let(:client) { Client.new(player, 'abc123') }

  describe '#initialize' do
    subject { client }
    it { is_expected.to be_a Client }
  end
end
