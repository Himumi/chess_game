class Chess
  attr_reader :board, :players
  def initialize(first, last)
    @board = create_board
    @players = [first, last]
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
end
