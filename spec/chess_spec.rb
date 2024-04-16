require './lib/chess'

describe Chess do
  let(:first) { double('Player' ) }
  let(:last) { double('Player') }
  subject(:game) { described_class.new(first, last) }
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

  describe '#valid_input?' do
    context 'when user input value' do
      it 'returns true if input is between a1..h8' do
        input = "a1"
        check_input = game.valid_input?(input)
        expect(check_input).to eq(true)
      end

      it 'returns false if input is not between a1..h8' do
        input = "l1"
        check_input = game.valid_input?(input)
        expect(check_input).not_to eq(true)
      end
    end
  end

  describe '#convert_to_number' do
    context 'when user inputs valid value (a1)' do

      it 'returns 11' do
        input = "a1"
        converted_input = game.convert_to_number(input)
        expect(converted_input).to eq("11")
      end
    end

    context 'when user inputs invalid value (l0)' do
      it 'returns nil' do
        input = "l0"
        converted_input = game.convert_to_number(input)
        expect(converted_input).to be_nil
      end
    end
  end
end
