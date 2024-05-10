require './lib/validation'
class Pieces
  include Validation

  attr_reader :color, :role, :symbol, :valid_movement, :letter

  def initialize(key, color, game)
    @key = key
    @color = color
    @game = game
    @moved = false
    @round = 0
  end

  attr_accessor :game, :moved, :key, :round

  def symbols
    return @marker[0] if color.eql?('white')

    @marker[1] if color.eql?('black')
  end

  def update_valid_move
    board = game.board
    result = []

    @max_paths.times do |path|
      stop = false
      current_position = key # to reset current position

      @max_each_direction.times do
        curr_key = direction(current_position, path)

        invalid_key = curr_key.nil?
        empty = board[curr_key].nil?

        if stop or invalid_key or (!empty and board[curr_key].color.eql?(color))
          stop = true
          next
        end
        # to prevent piece to leap over when meet opponent
        stop = true if !empty and board[curr_key].color != color

        current_position = curr_key
        result << curr_key
      end
    end
    @valid_movement = result
  end

  def to_s
    "#{symbol}"
  end
end

class King < Pieces
  def initialize(key, color, game)
    super(key, color, game)
    @role = 'king'
    @marker = ["\u2654", "\u265A"]
    @symbol = symbols
    @letter = 'K'
    @max_paths = 8
    @max_each_direction = 1
  end

  def direction(key, path)
    key = convert_to_number(key).chars
    a = key[0].to_i
    b = key[1].to_i

    paths = [
      [a - 1, b], [a - 1, b + 1], [a, b + 1], [a + 1, b + 1],
      [a + 1, b], [a + 1, b - 1], [a, b - 1], [a - 1, b - 1]
    ]

    convert_to_key(paths[path].join)
  end
end

class Queen < Pieces
  def initialize(key, color, game)
    super(key, color, game)
    @role = 'queen'
    @marker = ["\u2655", "\u265B"]
    @symbol = symbols
    @letter = 'Q'
    @max_paths = 8
    @max_each_direction = 7
  end

  def direction(key, path)
    key = convert_to_number(key).chars
    a = key[0].to_i
    b = key[1].to_i

    paths = [
      [a - 1, b], [a - 1, b + 1], [a, b + 1], [a + 1, b + 1],
      [a + 1, b], [a + 1, b - 1], [a, b - 1], [a - 1, b - 1]
    ]

    convert_to_key(paths[path].join)
  end
end

class Bishop < Pieces
  def initialize(key, color, game)
    super(key, color, game)
    @role = 'bishop'
    @marker = ["\u2657", "\u265D"]
    @symbol = symbols
    @letter = 'B'
    @max_paths = 4
    @max_each_direction = 7
  end

  def direction(key, path)
    key = convert_to_number(key).chars
    a = key[0].to_i
    b = key[1].to_i

    paths = [
      [a - 1, b + 1], [a + 1, b + 1], [a + 1, b - 1], [a - 1, b - 1]
    ]

    convert_to_key(paths[path].join)
  end
end

class Knight < Pieces
  def initialize(key, color, game)
    super(key, color, game)
    @role = 'knight'
    @marker = ["\u2658", "\u265E"]
    @symbol = symbols
    @letter = 'N'
    @max_paths = 8
    @max_each_direction = 1
  end

  def direction(key, path)
    key = convert_to_number(key).chars
    a = key[0].to_i
    b = key[1].to_i

    paths = [
      [a - 2, b + 1], [a - 1, b + 2], [a + 1, b + 2], [a + 2, b + 1],
      [a + 2, b - 1], [a + 1, b - 2], [a - 1, b - 2], [a - 2, b - 1]
    ]
    convert_to_key(paths[path].join)
  end
end

class Rook < Pieces
  def initialize(key, color, game)
    super(key, color, game)
    @role = 'rook'
    @marker = ["\u2656", "\u265C"]
    @symbol = symbols
    @letter = "R"
    @max_paths = 4
    @max_each_direction = 7
  end

  def direction(key, path)
    key = convert_to_number(key).chars
    a = key[0].to_i
    b = key[1].to_i

    paths = [
      [a - 1, b], [a, b + 1], [a + 1, b], [a, b - 1]
    ]

    convert_to_key(paths[path].join)
  end
end

class Pawn < Pieces
  def initialize(key, color, game)
    super(key, color, game)
    @role = 'pawn'
    @marker = ["\u2659", "\u265F"]
    @symbol = symbols
    @letter = ''
    @two_step = false
  end

  attr_accessor :two_step

  def update_valid_move
    @valid_movement = valid_move + capturable_move
  end

  def valid_move
    board = game.board
    current_position = key
    stop = false
    result = []

    max_move = @moved ? 1 : 2 # when false can move 2 step

    max_move.times do
      curr_key = valid_direction(current_position)

      empty = board[curr_key].nil?
      invalid_key = curr_key.nil?

      next stop = true if stop or invalid_key or !empty

      current_position = curr_key
      result << curr_key
    end
    result
  end

  def capturable_move
    board = game.board
    current_position = key
    result = []

    2.times do |path|
      curr_key = capturable_direction(current_position, path)

      invalid_key = curr_key.nil?
      empty = board[curr_key].nil?

      next if invalid_key or empty or board[curr_key].color.eql?(color) # is ally

      result << curr_key
    end
    result
  end

  def valid_direction(key)
    key = convert_to_number(key).chars
    a = key[0].to_i
    b = key[1].to_i

    paths = {
      'white' => [a, b + 1],
      'black' => [a, b - 1]
    }

    convert_to_key(paths[color].join)
  end

  def capturable_direction(key, path)
    key = convert_to_number(key).chars
    a = key[0].to_i
    b = key[1].to_i

    paths = {
      'white' => [[a - 1, b + 1], [a + 1, b + 1]],
      'black' => [[a - 1, b - 1], [a + 1, b - 1]]
    }

    convert_to_key(paths[color][path].join)
  end

  def en_passant_piece(key)
    key = convert_to_number(key).chars
    a = key[0].to_i
    b = key[1].to_i

    paths = {
      'white' => [a, b - 1],
      'black' => [a, b + 1]
    }

    convert_to_key(paths[color].join)
  end
end
