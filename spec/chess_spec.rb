require './lib/chess.rb'
require './lib/pieces.rb'
require './lib/player.rb'

describe Chess do
  subject(:game) { Chess.new(WhitePlayer, BlackPlayer) }
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

  describe '#convert_to_key' do
    context 'when input is 00 (valid input)' do
      it 'returns a1' do
        input = "11"
        converted_input = game.convert_to_key(input)
        expect(converted_input).to eq("a1")
      end
    end

    context 'when input is -10 (invalid input)' do
      it 'returns nil' do
        input = "-10"
        converted_input = game.convert_to_key(input)
        expect(converted_input).to be_nil
      end
    end
  end
end
