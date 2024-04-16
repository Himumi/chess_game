require './lib/chess'

describe Chess do
  subject(:game) { described_class.new() }
  describe '#create_board' do
    context 'when method is called' do

      let(:board) { game.create_board }

      it 'first key is a8' do
        first_key = board.keys.first
        expect(first_key).to eq('a8')
      end

      it 'last key is h0' do
        last_keys = board.keys.last
        expect(last_keys).to eq('h1')
      end
    end
  end
end
