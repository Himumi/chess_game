class Pieces
  attr_reader :key, :color, :role, :symbol, :marker
  def initialize(key, color)
    @key = key
    @color = color
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
  def initialize(key, color)
    super(key, color)
    @role = "king"
    @marker = ["\u2654", "\u265A"]
    @symbol = symbols
  end
end

class Queen < Pieces
  def initialize(key, color)
    super(key, color)
    @role = "queen"
    @marker = ["\u2655", "\u265B"]
    @symbol = symbols
  end
end

class Bishop < Pieces
  def initialize(key, color)
    super(key, color)
    @role = "bishop"
    @marker = ["\u2657", "\u265D"]
    @symbol = symbols
  end
end

class Knight < Pieces
  def initialize(key, color)
    super(key, color)
    @role = "knight"
    @marker = ["\u2658", "\u265E"]
    @symbol = symbols
  end
end

class Rook < Pieces
  def initialize(key, color)
    super(key, color)
    @role = "rook"
    @marker = ["\u2656", "\u265C"]
    @symbol = symbols
  end
end

class Pawn < Pieces
  def initialize(key, color)
    super(key, color)
    @role = "pawn"
    @marker = ["\u2659", "\u265F"]
    @symbol = symbols
  end
end
