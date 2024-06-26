require './lib/pieces'
require './lib/validation'
class Chess
  include Validation

  attr_reader :board, :players, :en_passant
  attr_accessor :round, :notation

  def initialize(first, last)
    @players = [first.new(self, 'foo'), last.new(self, 'hoo')]
    @board = create_board
    @current_player_id = 0
    @round = 1
    @en_passant = false
    @notation = []
  end

  def create_board
    board = {}

    ('1'..'8').to_a.reverse.each do |number|
      ('a'..'h').each { |letter| board["#{letter}#{number}"] = nil }
    end
    board
  end

  def print_board
    display = ''
    letters = '  '
    count = 8
    dashes = "   - - - - - - - - - - - - - - - -\n"
    ('A'..'H').each { |letter| letters += "  #{letter} " }
    @board.each do |key, item|
      if key[0] == 'a'
        first = "\n#{dashes}#{count} |   |"
        second = "\n#{dashes}#{count} | #{item} |"
        display += item.nil? ? first : second
        count -= 1
        next
      end
      display += item.nil? ? '   |' : " #{item} |"
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
      'king' => King.new(key, color, self),
      'queen' => Queen.new(key, color, self),
      'bishop' => Bishop.new(key, color, self),
      'knight' => Knight.new(key, color, self),
      'rook' => Rook.new(key, color, self),
      'pawn' => Pawn.new(key, color, self)
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

  def update_all_pieces_valid_moves
    @players.each do |player|
      player.all_valid_moves = []
      player.available_pieces.each do |piece|
        @board[piece].update_valid_move
        player.all_valid_moves << @board[piece].valid_movement
      end
      player.all_valid_moves.flatten!.uniq!
    end
  end

  def update_checked_mated
    @players.each_with_index do |player, i|
      king_key = player.pieces["king"][0]
      other_king_valid_moves = @players[i - 1].all_valid_moves

      player.checked = other_king_valid_moves.include?(king_key)

      player.mated = @board[king_key].valid_movement.all? { |v| other_king_valid_moves.include?(v) }
    end
  end

  def won?
    @players.any? { |player| player.checked and player.mated }
  end

  def stalemated?
    all_valid_moves = current_player.all_valid_moves
    king_valid_moves = @board[current_player.pieces['king'][0]].valid_movement
    not_has_legal_moves = (all_valid_moves - king_valid_moves).empty?

    current_player.mated and !current_player.checked and not_has_legal_moves
  end

  def add_notation(source, destination)
    @board[destination].nil? ? move_notation(source, destination) : captured_notation(source, destination)
  end

  def move_notation(source, destination)
    source_letter = @board[source].letter
    @notation << "#{source_letter}#{source}#{destination}"
  end

  def captured_notation(source, destination)
    source_letter = @board[source].letter
    @notation << "#{source_letter}#{source}x#{destination}"
  end
end
