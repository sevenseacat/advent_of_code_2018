defmodule Day15Test do
  use ExUnit.Case
  doctest Day15
  alias Day15.Unit

  describe "parse_input" do
    test "it can read a sample grid" do
      {:ok, input} = File.read("test/data/day_15/parse_input")

      expected_output = {
        # Units
        [
          %Unit{type: :goblin, hp: 200, position: {2, 3}},
          %Unit{type: :elf, hp: 200, position: {2, 5}},
          %Unit{type: :elf, hp: 200, position: {3, 2}},
          %Unit{type: :goblin, hp: 200, position: {3, 4}},
          %Unit{type: :elf, hp: 200, position: {3, 6}},
          %Unit{type: :goblin, hp: 200, position: {4, 3}},
          %Unit{type: :elf, hp: 200, position: {4, 5}}
        ],

        # Movable squares
        MapSet.new([
          {2, 2},
          {2, 3},
          {2, 4},
          {2, 5},
          {2, 6},
          {3, 2},
          {3, 3},
          {3, 4},
          {3, 5},
          {3, 6},
          {4, 2},
          {4, 3},
          {4, 5},
          {4, 6}
        ])
      }

      assert Day15.parse_input(input) == expected_output
    end
  end
end
