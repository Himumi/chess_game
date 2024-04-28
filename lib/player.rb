class Player
  attr_reader :pieces, :color
  attr_accessor :name, :game, :pieces, :all_valid_moves, :checked, :mated

  def initialize(game, name)
    @game = game
    @name = name
    @all_valid_moves = []
    @checked = false
    @mated = false
  end

  def available_pieces
    @pieces.values.flatten
  end

  def move(source, destination)
    destination_piece = game.board[destination]

    return en_passant_move(source, destination) if game.en_passant

    if destination_piece.nil?
      nil_at_destination(source, destination)
    else
      opponent_at_destination(source, destination)
    end
  end

  def nil_at_destination(source, destination)
    add_round_game(source)
    pawn_two_step(source, destination)

    piece_role = game.board[source].role # update_@pieces_list
    @pieces[piece_role].delete(source)
    @pieces[piece_role].push(destination)

    game.board[destination] = game.board[source] # move_piece_to_destination
    game.board[destination].key = destination # update_piece.key_to_new_key
    game.board[source] = nil # delete_piece
  end

  def opponent_at_destination(source, destination)
    game.opponent_player.pieces[game.board[destination].role].delete(destination)
    nil_at_destination(source, destination)
  end

  def add_round_game(source)
    game.board[source].round = game.round
  end

  def pawn_two_step(source, destination)
    s = source
    d = destination
    board = game.board

    return unless board[s].role.eql?('pawn')

    game.board[s].two_step = valid_two_step_position(s, d)
  end

  def valid_two_step_position(source, destination)
    s = source
    d = destination
    s[0].eql?(d[0]) and (d[1].to_i - s[1].to_i).abs.eql?(2)
  end

  def en_passant_move(source, destination)
    en_passant_key = game.board[source].en_passant_piece(destination)

    nil_at_destination(source, destination) # move_source_piece_to_destinatio

    game.board[en_passant_key] = nil # delete_opponent_piece
    game.opponent_player.pieces['pawn'].delete(en_passant_key) # update_opponent_@pieces_list
  end
end

class WhitePlayer < Player
  def initialize(game, name)
    super(game, name)
    @pieces = {
      'king' => ['e1'],
      'queen' => ['d1'],
      'bishop' => %w[c1 f1],
      'knight' => %w[b1 g1],
      'rook' => %w[a1 h1],
      'pawn' => %w[a2 b2 c2 d2 e2 f2 g2 h2]
    }
    @color = 'white'
  end
end

class BlackPlayer < Player
  def initialize(game, name)
    super(game, name)
    @pieces = {
      'king' => ['e8'],
      'queen' => ['d8'],
      'bishop' => %w[c8 f8],
      'knight' => %w[b8 g8],
      'rook' => %w[a8 h8],
      'pawn' => %w[a7 b7 c7 d7 e7 f7 g7 h7]
    }
    @color = 'black'
  end
end
