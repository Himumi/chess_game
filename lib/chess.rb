class Chess
  attr_reader :board
  def initialize
    @board = create_board
  end

  def create_board
    board = {}

    ("1".."8").to_a.reverse.each do |number|
      ("a".."h").each { |letter| board["#{letter}#{number}"] = nil }
    end
    board
  end
end

# game = Chess.new

# game.print_board
