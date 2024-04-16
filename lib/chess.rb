require_relative 'pieces'
class Chess
  attr_reader :board, :players
  def initialize(first, last)
    @players = [first, last]
    @board = create_board
  end

  def create_board
    board = {}

    ("1".."8").to_a.reverse.each do |number|
      ("a".."h").each { |letter| board["#{letter}#{number}"] = nil }
    end
    board = add_pieces_to_board(board)
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

  def add_pieces_to_board(board)
    players.each do |player|
      player.pieces.each do |role, keys|
        keys.each { |key| board[key] = new_piece(role, key, player.color) }
      end
    end
    board
  end

  def new_piece(role, key, color)
    new = {
      "king" => King.new(key, color),
      "queen" => Queen.new(key, color),
      "bishop" => Bishop.new(key, color),
      "knight" => Knight.new(key, color),
      "rook" => Rook.new(key, color),
      "pawn" => Pawn.new(key, color),
    }
    new[role]
  end
end
