require './lib/pieces'
require './lib/validation'
class Chess
  include Validation

  attr_reader :board, :players
  attr_accessor :round
  def initialize(first, last)
    @players = [first.new(self, "foo"), last.new(self, "hoo")]
    @board = create_board
    @current_player_id = 0
    @round = 1
  end

  def create_board
    board = {}

    ("1".."8").to_a.reverse.each do |number|
      ("a".."h").each { |letter| board["#{letter}#{number}"] = nil }
    end
    board
  end

  def print_board
    display, letters, count = "", "  ", 8
    dashes = "   - - - - - - - - - - - - - - - -\n"
    ("A".."H").each { |letter| letters += "  #{letter} " }
    @board.each do |key, item|
      if key[0] == "a"
        first = "\n#{dashes}#{count} |   |"
        second = "\n#{dashes}#{count} | #{item} |"
        display += item.nil? ? first : second
        count -= 1
        next
      end
      display += item.nil? ? "   |" : " #{item} |"
    end
    puts display + "\n#{dashes}" + letters
  end

  def add_pieces_to_board
    players.each do |player|
      player.pieces.each do |role, keys|
        keys.each { |key| board[key] = new_piece(role, key, player.color) }
      end
    end
  end

  def new_piece(role, key, color)
    new = {
      "king" => King.new(key, color, self),
      "queen" => Queen.new(key, color, self),
      "bishop" => Bishop.new(key, color, self),
      "knight" => Knight.new(key, color, self),
      "rook" => Rook.new(key, color, self),
      "pawn" => Pawn.new(key, color, self),
    }
    new[role]
  end

  def add_to_board(piece)
    @board[piece.key] = piece
  end

  def opponent_player_id
    1 - @current_player_id
  end

  def current_player
    @players[@current_player_id]
  end

  def opponent_player
    @players[opponent_player_id]
  end

  def switch_player
    @current_player_id = opponent_player_id
  end
end
