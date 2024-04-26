class Player
  attr_reader :pieces, :color
  attr_accessor :name, :game, :available_pieces

  def initialize(game, name)
    @game = game
    @name = name
  end

  def move(source, destination)
    destination_piece = game.board[destination]

    return en_passant_move(source, destination) if game.en_passant
    
    destination_piece.nil? ?
      nil_at_destination(source, destination) :
      opponent_at_destination(source, destination)
  end

  def nil_at_destination(source, destination)
    add_round_game(source)
    pawn_two_step(source, destination)

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

  def add_round_game(source)
    game.board[source].round = game.round
  end

  def pawn_two_step(source, destination)
    s, d, board = source, destination, game.board

    if board[s].role.eql?("pawn")
      game.board[s].two_step = valid_two_step_position(s, d)
    end
  end

  def valid_two_step_position(source, destination)
    s, d = source, destination
    s[0].eql?(d[0]) and (d[1].to_i - s[1].to_i).abs.eql?(2)
  end

  def en_passant_move(source, destination)
    en_passant_key = game.board[source].en_passant_piece(destination)
    # get opponent_key
    nil_at_destination(source, destination) # move source piece to nil board

    game.board[en_passant_key] = nil # delete opponent piece
    game.opponent_player.available_pieces.delete(en_passant_key) # delete opponent key from list
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
