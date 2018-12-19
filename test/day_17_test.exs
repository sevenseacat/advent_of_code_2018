defmodule Day17Test do
  use ExUnit.Case
  doctest Day17

  describe "part 1" do
    test "edge case" do
      {from, state} = File.read!("test/data/day_17/edge_case") |> Day17.parse_picture_input()
      assert Day17.part1(state, from) == 337
    end
  end
end
