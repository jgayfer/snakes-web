RSpec.describe SnakesAPI::Responses::EmptyResponse do
  let(:empty_response) { described_class.new }

  describe '#initialize' do
    subject { empty_response }
    it { is_expected.to be_a described_class }
  end

  describe '#to_s' do
    subject { empty_response.to_s }
    it 'returns an empty json string' do
      expect(subject).to eq(fixture('empty_response.json').chomp)
    end
  end
end
