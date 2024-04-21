class Player
  attr_reader :pieces, :color
  attr_accessor :name, :game, :available_pieces

  def initialize(game, name)
    @game = game
    @name = name
  end

  def nil_at_destination(source, destination)
    game.board[destination] = game.board[source] # move piece to destination
    game.board[destination].key = destination # update piece key to new one
    game.board[source] = nil # delete piece
    @available_pieces.delete(source)
    @available_pieces.push(destination)
  end

  def opponent_at_destination(source, destination)
    game.opponent_player.available_pieces.delete(destination)
    nil_at_destination(source, destination)
  end
end

class WhitePlayer < Player
  def initialize(game, name)
    super(game, name)
    @pieces = {
      "king" => ["e1"],
      "queen" => ["d1"],
      "bishop" => ["c1", "f1"],
      "knight" => ["b1", "g1"],
      "rook" => ["a1", "h1"],
      "pawn" => ["a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2"]
    }
    @available_pieces = pieces.values.flatten
    @color = 'white'
  end
end

class BlackPlayer < Player
  def initialize(game, name)
    super(game, name)
    @pieces = {
      "king" => ["e8"],
      "queen" => ["d8"],
      "bishop" => ["c8", "f8"],
      "knight" => ["b8", "g8"],
      "rook" => ["a8", "h8"],
      "pawn" => ["a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7"]
    }
    @available_pieces = pieces.values.flatten
    @color = 'black'
  end
end
