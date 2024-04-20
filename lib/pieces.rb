require './lib/validation.rb'
class Pieces
  include Validation

  attr_reader :key, :color, :role, :symbol, :marker, :valid_movement
  attr_accessor :game, :moved

  def initialize(key, color, game)
    @key = key
    @color = color
    @game = game
    @moved = false
  end

  def symbols
    return marker[0] if color.eql?("white")
    return marker[1] if color.eql?("black")
  end

  def update_valid_move
    board, result = game.board, []

    @max_paths.times do |path|
      stop, current_position = false, key #to reset current position

      @max_each_direction.times do
        curr_key = direction(current_position, path)

        invalid_key = curr_key.nil?
        empty = board[curr_key].nil?

        if stop or invalid_key or (!empty and board[curr_key].color.eql?(color))
          stop = true
          next
        end

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
    @role = "king"
    @marker = ["\u2654", "\u265A"]
    @symbol = symbols
    @max_paths = 8
    @max_each_direction = 1
  end

  def direction(key, index)
    key = convert_to_number(key).chars
    a, b = key[0].to_i, key[1].to_i

    paths = [
      [a-1, b], [a-1, b+1], [a, b+1], [a+1, b+1],
      [a+1, b], [a+1, b-1], [a, b-1], [a-1, b-1]
    ]

    convert_to_key(paths[index].join)
  end
end

class Queen < Pieces
  def initialize(key, color, game)
    super(key, color, game)
    @role = "queen"
    @marker = ["\u2655", "\u265B"]
    @symbol = symbols
    @max_paths = 8
    @max_each_direction = 7
  end

  def direction(key, index)
    key = convert_to_number(key).chars
    a, b = key[0].to_i, key[1].to_i

    paths = [
      [a-1, b], [a-1, b+1], [a, b+1], [a+1, b+1],
      [a+1, b], [a+1, b-1], [a, b-1], [a-1, b-1]
    ]

    convert_to_key(paths[index].join)
  end
end

class Bishop < Pieces
  def initialize(key, color, game)
    super(key, color, game)
    @role = "bishop"
    @marker = ["\u2657", "\u265D"]
    @symbol = symbols
    @max_paths = 4
    @max_each_direction = 7
  end

  def direction(key, index)
    key = convert_to_number(key).chars
    a, b = key[0].to_i, key[1].to_i

    paths = [
      [a-1, b+1], [a+1, b+1], [a+1, b-1], [a-1, b-1]
    ]

    convert_to_key(paths[index].join)
  end
end

class Knight < Pieces
  def initialize(key, color, game)
    super(key, color, game)
    @role = "knight"
    @marker = ["\u2658", "\u265E"]
    @symbol = symbols
    @max_paths = 8
    @max_each_direction = 1
  end

  def direction(key, index)
    key = convert_to_number(key).chars
    a, b = key[0].to_i, key[1].to_i

    paths = [
      [a-2, b+1], [a-1, b+2], [a+1, b+2], [a+2, b+1],
      [a+2, b-1], [a+1, b-2], [a-1, b-2], [a-2, b-1]
    ]
    convert_to_key(paths[index].join)
  end
end

class Rook < Pieces
  def initialize(key, color, game)
    super(key, color, game)
    @role = "rook"
    @marker = ["\u2656", "\u265C"]
    @symbol = symbols
    @max_paths = 4
    @max_each_direction = 7
  end

  def direction(key, index)
    key = convert_to_number(key).chars
    a, b = key[0].to_i, key[1].to_i

    paths = [
      [a-1, b], [a, b+1], [a+1, b], [a, b-1]
    ]

    convert_to_key(paths[index].join)
  end
end

class Pawn < Pieces
  def initialize(key, color, game)
    super(key, color, game)
    @role = "pawn"
    @marker = ["\u2659", "\u265F"]
    @symbol = symbols
  end

  def valid_move
    board, current_position, stop, result = game.board, key, false, []

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
    board, current_position, result = game.board, key, []

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
    a, b = key[0].to_i, key[1].to_i

    direction = { "white" => [a, b+1], "black" => [a, b-1] }

    convert_to_key(direction[color].join)
  end

  def capturable_direction(key, path)
    key = convert_to_number(key).chars
    a, b = key[0].to_i, key[1].to_i

    directions = { "white" => [[a-1, b+1], [a+1, b+1]], "black" => [[a-1, b-1], [a+1, b-1]] }

    convert_to_key(directions[color][path].join)
  end
end
