defmodule Day15Test do
  use ExUnit.Case
  doctest Day15
  alias Day15.Unit

  describe "part1" do
    test "it works for sample input 0" do
      {:ok, input} = File.read("test/data/day_15/turn_by_turn")

      assert Day15.part1(input) == %{
               winner: "G",
               rounds: 47,
               hp_left: 590,
               score: 27730,
               elves_dead: 2
             }
    end

    test "it works for sample input 1" do
      {:ok, input} = File.read("test/data/day_15/full_match_1")

      assert Day15.part1(input) == %{
               winner: "E",
               rounds: 37,
               hp_left: 982,
               score: 36334,
               elves_dead: 1
             }
    end

    test "it works for sample input 2" do
      {:ok, input} = File.read("test/data/day_15/full_match_2")

      assert Day15.part1(input) == %{
               winner: "E",
               rounds: 46,
               hp_left: 859,
               score: 39514,
               elves_dead: 1
             }
    end

    test "it works for sample input 3" do
      {:ok, input} = File.read("test/data/day_15/full_match_3")

      assert Day15.part1(input) == %{
               winner: "G",
               rounds: 35,
               hp_left: 793,
               score: 27755,
               elves_dead: 2
             }
    end

    test "it works for sample input 4" do
      {:ok, input} = File.read("test/data/day_15/full_match_4")

      assert Day15.part1(input) == %{
               winner: "G",
               rounds: 54,
               hp_left: 536,
               score: 28944,
               elves_dead: 2
             }
    end

    test "it works for sample input 5" do
      {:ok, input} = File.read("test/data/day_15/full_match_5")

      assert Day15.part1(input) == %{
               winner: "G",
               rounds: 20,
               hp_left: 937,
               score: 18740,
               elves_dead: 1
             }
    end
  end

  describe "part2" do
    test "sample input 1" do
      {:ok, input} = File.read("test/data/day_15/part_2_first")

      assert Day15.part2(input) == %{
               winner: "E",
               rounds: 29,
               hp_left: 172,
               score: 4988,
               elves_dead: 0,
               power: 15
             }
    end
  end

  describe "parse_input" do
    test "it can read a sample grid" do
      {:ok, input} = File.read("test/data/day_15/parse_input")

      expected_units = [
        %Unit{type: "G", hp: 200, position: {2, 3}, alive: true, power: 3},
        %Unit{type: "E", hp: 200, position: {2, 5}, alive: true, power: 3},
        %Unit{type: "E", hp: 200, position: {3, 2}, alive: true, power: 3},
        %Unit{type: "G", hp: 200, position: {3, 4}, alive: true, power: 3},
        %Unit{type: "E", hp: 200, position: {3, 6}, alive: true, power: 3},
        %Unit{type: "G", hp: 200, position: {4, 3}, alive: true, power: 3},
        %Unit{type: "E", hp: 200, position: {4, 5}, alive: true, power: 3}
      ]

      expected_vertices = [
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
      ]

      {units, graph} = Day15.parse_input(input)

      assert expected_units == units
      assert expected_vertices == Graph.vertices(graph) |> Enum.sort()
    end
  end

  describe "do_round" do
    test "first round" do
      state = File.read!("test/data/day_15/turn_by_turn") |> Day15.parse_input()

      # Coords don't change, we only care about units.
      expected_units = [
        %Unit{type: "G", hp: 200, position: {2, 4}, alive: true, power: 3},
        %Unit{type: "E", hp: 197, position: {3, 5}, alive: true, power: 3},
        %Unit{type: "G", hp: 197, position: {3, 6}, alive: true, power: 3},
        %Unit{type: "G", hp: 200, position: {4, 4}, alive: true, power: 3},
        %Unit{type: "G", hp: 197, position: {4, 6}, alive: true, power: 3},
        %Unit{type: "E", hp: 197, position: {5, 6}, alive: true, power: 3}
      ]

      assert Day15.do_round(state) == expected_units
    end

    test "second round" do
      {units, graph} = File.read!("test/data/day_15/turn_by_turn") |> Day15.parse_input()

      # Coords don't change, we only care about units.
      expected_units = [
        %Unit{type: "G", hp: 200, position: {2, 5}, alive: true, power: 3},
        %Unit{type: "G", hp: 200, position: {3, 4}, alive: true, power: 3},
        %Unit{type: "E", hp: 188, position: {3, 5}, alive: true, power: 3},
        %Unit{type: "G", hp: 194, position: {3, 6}, alive: true, power: 3},
        %Unit{type: "G", hp: 194, position: {4, 6}, alive: true, power: 3},
        %Unit{type: "E", hp: 194, position: {5, 6}, alive: true, power: 3}
      ]

      units = Day15.do_round({units, graph})
      assert Day15.do_round({units, graph}) == expected_units
    end

    test "first death" do
      {units, graph} = File.read!("test/data/day_15/turn_by_turn") |> Day15.parse_input()

      # Coords don't change, we only care about units.
      expected_units = [
        %Unit{type: "G", hp: 200, position: {2, 5}, alive: true, power: 3},
        %Unit{type: "G", hp: 200, position: {3, 4}, alive: true, power: 3},
        %Unit{type: "G", hp: 131, position: {3, 6}, alive: true, power: 3},
        %Unit{type: "G", hp: 131, position: {4, 6}, alive: true, power: 3},
        %Unit{type: "E", hp: 131, position: {5, 6}, alive: true, power: 3}
      ]

      units =
        1..23
        |> Enum.reduce(units, fn _, units ->
          Day15.do_round({units, graph})
        end)

      assert units == expected_units
    end

    test "all units movement" do
      units =
        File.read!("test/data/day_15/all_units_movement")
        |> Day15.parse_input()
        |> Day15.do_round()

      positions = Enum.map(units, fn u -> u.position end)
      assert positions == [{2, 3}, {2, 7}, {3, 5}, {4, 5}, {4, 8}, {5, 3}, {7, 2}, {7, 5}, {7, 8}]
    end
  end

  describe "new_position" do
    test "can move a unit" do
      {:ok, input} = File.read("test/data/day_15/movement")
      input = Day15.parse_input(input)

      assert Day15.new_position(%Unit{type: "E", hp: 200, position: {2, 3}}, input) == {2, 4}
    end

    test "more movement" do
      {units, graph} = File.read!("test/data/day_15/more_movement") |> Day15.parse_input()
      assert Day15.new_position(hd(units), {units, graph}) == {2, 3}
    end

    test "more movement 2" do
      {units, graph} = File.read!("test/data/day_15/more_movement_2") |> Day15.parse_input()
      assert Day15.new_position(hd(units), {units, graph}) == {1, 1}
    end
  end
end
