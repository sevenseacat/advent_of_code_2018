defmodule Day19Test do
  use ExUnit.Case
  doctest Day19

  describe "part 1" do
    test "it works with sample input" do
      input = File.read!("test/data/day_19")
      output = [6, 5, 6, 0, 0, 9]

      assert Day19.part1(input) == output
    end
  end

  describe "parse_input" do
    test "it reads the input properly" do
      input = File.read!("test/data/day_19")

      output = %{
        ip: 0,
        commands: %{
          0 => {:seti, 5, 0, 1},
          1 => {:seti, 6, 0, 2},
          2 => {:addi, 0, 1, 0},
          3 => {:addr, 1, 2, 3},
          4 => {:setr, 1, 0, 0},
          5 => {:seti, 8, 0, 4},
          6 => {:seti, 9, 0, 5}
        }
      }

      assert Day19.parse_input(input) == output
    end
  end
end
