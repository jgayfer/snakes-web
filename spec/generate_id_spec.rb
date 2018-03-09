RSpec.describe SnakesAPI::GenerateID do
  describe '.call' do
    subject { described_class.call }
    it 'returns a string' do
      expect(subject).to be_a String
    end
  end
end
