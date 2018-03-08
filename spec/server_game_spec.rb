require 'server_game'
require 'client'
require 'snakes'
require 'securerandom'

RSpec.describe ServerGame do
  let(:game) { Snakes.standard_game([]) }
  let(:client) { Client.new(Snakes::Player.new('dummy'), '123abc') }
  let(:client2) { Client.new(Snakes::Player.new('dummy2'), '123abc') }
  let(:server_game) { ServerGame.new(game, '123abc') }

  describe '#initialize' do
    subject { server_game }
    it { is_expected.to be_a ServerGame }
  end

  describe '#add_client' do
    subject { server_game }
    before { server_game.add_client(client) }

    it 'added a new client' do
      expect(subject.clients.first).to be_a Client
      expect(subject.game.previous_player).to eq(client.player)
    end
  end

  describe '#client_id_in_game?' do
    subject { server_game.client_id_in_game?(client.id) }

    context 'client in game' do
      before { server_game.add_client(client) }
      it { is_expected.to be_truthy }
    end

    context 'client not in game' do
      it { is_expected.to be_falsey }
    end
  end

  describe '#client_id_is_next_player?' do
    subject { server_game.client_id_is_next_player?(client.id) }
    before { server_game.add_client(client) }
    before { server_game.add_client(client2) }

    context 'client is next player' do
      it { is_expected.to be_truthy }
    end

    context 'client is not next player' do
      before { server_game.game.move_next_player }
      it { is_expected.to be_falsey }
    end
  end

  describe '#start_game' do
    subject { server_game.game_has_started }

    it 'gets set to true' do
      server_game.start_game
      expect(subject).to be_truthy
    end
  end
end
