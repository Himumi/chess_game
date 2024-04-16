module Validation
  def valid_input?(input)
    return false unless input.length.eql?(2)

    input[0].between?("a","h") and input[1].between?("1","8")
  end

  def convert_to_number(input)
    return nil unless valid_input?(input)
    input = input.chars

    letters = {"a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "h" => 8}
    input[0] = letters[input[0]]
    input.join
  end

  def convert_to_key(input)
    input = input.chars
    return nil if invalid?(input)

    letters = {"1" => "a", "2" => "b", "3" => "c", "4" => "d", "5" => "e", "6" => "f", "8" => "h" }
    input[0] = letters[input[0]]
    input.join
  end

  def invalid?(array)
    array.length > 3 or array.any? { |item| !item.between?("1", "8") }
  end
end
