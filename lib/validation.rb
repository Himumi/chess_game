module Validation
  def valid_input?(input)
    return false unless input.length.eql?(2)

    input[0].between?("a","h") and input[1].between?("1","8")
  end

  def convert_to_number(input)
    return nil unless valid_input?(input)
    input = input.chars

    letters = {
      "a" => 1, "b" => 2, "c" => 3, "d" => 4,
      "e" => 5, "f" => 6, "g" => 7, "h" => 8
    }
    input[0] = letters[input[0]]
    input.join
  end

  def convert_to_key(input)
    input = input.chars
    return nil if invalid?(input)

    letters = {
      "1" => "a", "2" => "b", "3" => "c", "4" => "d",
      "5" => "e", "6" => "f", "7" => "g", "8" => "h"
    }
    input[0] = letters[input[0]]
    input.join
  end

  def invalid?(array)
    array.length > 3 or array.any? { |item| !item.between?("1", "8") }
  end

  # def en_passant?(source, destination)
  #   s_piece = game.board[source]
  #   d_piece = game.board[destination]

  #   return false if !s_piece.role.eql?("pawn") or !d_piece.nil?

  #   valid_round = (game.round - d_piece.round).eql?(1)

  #   s_number = convert_to_number(source).chars
  #   d_number = convert_to_number(destination).chars

  #   neighbor = [-1, 1].include?(s_number[0].to_i - d_number[0].to_i)

  #   d_piece.two_step and valid_round and neighbor
  # end
end
