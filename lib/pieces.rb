require './lib/validation.rb'
class Pieces
  include Validation

  attr_reader :key, :color, :role, :symbol, :marker, :max_paths, :max_each_direction
  attr_accessor :valid_movement, :game

  def initialize(key, color, game)
    @key = key
    @color = color
    @game = game
    @valid_movement = []
  end

  def symbols
    return marker[0] if color.eql?("white")
    return marker[1] if color.eql?("black")
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
end
