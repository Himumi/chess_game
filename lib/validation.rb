module Validation
  def valid_input?(input)
    return false unless input.length.eql?(2)

    input[0].between?('a', 'h') and input[1].between?('1', '8')
  end

  def convert_to_number(input)
    return nil unless valid_input?(input)

    input = input.chars

    letters = {
      'a' => 1, 'b' => 2, 'c' => 3, 'd' => 4,
      'e' => 5, 'f' => 6, 'g' => 7, 'h' => 8
    }
    input[0] = letters[input[0]]
    input.join
  end

  def convert_to_key(input)
    input = input.chars
    return nil if invalid?(input)

    letters = {
      '1' => 'a', '2' => 'b', '3' => 'c', '4' => 'd',
      '5' => 'e', '6' => 'f', '7' => 'g', '8' => 'h'
    }
    input[0] = letters[input[0]]
    input.join
  end

  def invalid?(array)
    array.length > 3 or array.any? { |item| !item.between?('1', '8') }
  end

  def en_passant?(source, destination)
    @en_passant = fulfilled_en_passant?(source, destination)
  end

  def fulfilled_en_passant?(source, destination)
    s = source
    d = destination

    ep_input?(s, d) and ep_target?(s, d) and ep_need?(s, d) and ep_adjacent?(s, d)
  end

  def ep_input?(source, destination)
    @board[source].role.eql?('pawn') and @board[destination].nil?
  end

  def ep_target?(source, destination)
    source_piece = @board[source]
    target_piece = @board[source_piece.en_passant_piece(destination)]

    target_piece.role.eql?('pawn') and !source_piece.color.eql?(target_piece.color)
  end

  def ep_need?(source, destination)
    source_piece = @board[source]
    target_piece = @board[source_piece.en_passant_piece(destination)]

    target_piece.two_step and (@round - target_piece.round).eql?(1)
  end

  def ep_adjacent?(source, destination)
    source_piece = @board[source]
    destination = source_piece.en_passant_piece(destination)

    s_key = convert_to_number(source).chars
    a = s_key[0].to_i
    b = s_key[1].to_i

    adjacents = [
      [a - 1, b], [a + 1, b]
    ]

    adjacents = adjacents.map { |v| convert_to_key(v.join) }

    adjacents.include?(destination)
  end
end
