defmodule Day15.Unit do
  defstruct [:type, :hp, :position, :alive, :power]
end

defmodule Day15 do
  alias Day15.Unit

  def part1(input) do
    {units, graph} = parse_input(input)

    do_part1({units, graph}, count_elves(units), 0)
  end

  def part2(input) do
    do_part2(input, %{"E" => 4, "G" => 3})
  end

  defp do_part1({units, graph}, elf_count, round_no) do
    {new_units, round_no} =
      try do
        {do_round({units, graph}), round_no + 1}
      catch
        new_units ->
          {new_units |> Enum.filter(fn unit -> unit.alive end), round_no}
      end

    if winner = battle_over?(new_units) do
      hp_left = Enum.map(new_units, fn unit -> unit.hp end) |> Enum.sum()

      %{
        winner: winner,
        hp_left: hp_left,
        rounds: round_no,
        score: round_no * hp_left,
        elves_dead: elf_count - count_elves(new_units)
      }
    else
      do_part1({new_units, graph}, elf_count, round_no)
    end
  end

  defp do_part2(input, power) do
    {units, graph} = parse_input(input, power)
    result = do_part1({units, graph}, count_elves(units), 0)

    if result.elves_dead == 0 do
      Map.put(result, :power, power["E"])
    else
      do_part2(input, %{power | "E" => power["E"] + 1})
    end
  end

  defp count_elves(units) do
    Enum.count(units, fn unit -> unit.type == "E" end)
  end

  def do_round({units, graph}) do
    Enum.reduce(units, {units, 0}, fn _unit, {temp_units, index} ->
      {take_turn(temp_units, graph, index), index + 1}
    end)
    |> elem(0)
    |> Enum.filter(fn unit -> unit.alive end)
    |> sort_units
  end

  defp take_turn(units, graph, index) do
    unit = Enum.at(units, index)

    if unit.alive do
      unit = %{unit | position: new_position(unit, {units, graph})}
      units = List.replace_at(units, index, unit)
      enemy = enemy_adjacent(unit, units)

      if enemy do
        attack_enemy(unit, enemy, units)
      else
        units
      end
    else
      units
    end
  end

  defp enemy_adjacent(%Unit{type: type, position: {row, col}}, units) do
    adjacent_coords = [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}]

    adjacent =
      units
      |> Enum.filter(fn possible ->
        possible.type != type && possible.alive &&
          Enum.member?(adjacent_coords, possible.position)
      end)

    case adjacent do
      [] ->
        nil

      units ->
        {_hp, weakest_units} =
          units
          |> Enum.group_by(fn unit -> unit.hp end)
          |> Enum.sort_by(fn {hp, _} -> hp end)
          |> hd()

        Enum.min_by(weakest_units, fn unit -> unit.position end)
    end
  end

  defp attack_enemy(attacker, target, units) do
    Enum.map(units, fn unit ->
      if unit == target do
        %{unit | hp: unit.hp - attacker.power, alive: unit.hp > attacker.power}
      else
        unit
      end
    end)
  end

  defp battle_over?(units) do
    grouped =
      units
      |> Enum.group_by(fn unit -> unit.type end)

    if map_size(grouped) == 1 do
      hd(units).type
    else
      false
    end
  end

  def new_position(unit, {units, graph}) do
    if find_enemies(unit, units) == [], do: throw(units)

    if enemy_adjacent(unit, units) do
      # Don't move, stay and attack.
      unit.position
    else
      # I like to move it move it
      calculate_new_position(unit, {units, graph})
    end
  end

  defp calculate_new_position(unit, {units, graph}) do
    paths =
      unit
      |> find_enemies(units)
      |> Enum.flat_map(fn unit -> get_squares_in_range(unit, units, graph) end)
      |> Enum.map(fn coord -> best_path_between(unit.position, coord, {units, graph}) end)
      |> Enum.filter(fn path -> path != nil end)
      |> Enum.group_by(fn path -> length(path) end)

    case map_size(paths) do
      0 ->
        unit.position

      _yay ->
        paths
        |> Enum.sort_by(fn {length, _} -> length end)
        |> hd
        |> get_first_move_by_reading_order
    end
  end

  defp get_squares_in_range(%Unit{position: {row, col}}, units, graph) do
    [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}]
    |> Enum.filter(fn {row, col} ->
      Graph.has_vertex?(graph, {row, col}) &&
        !Enum.any?(units, fn unit -> unit.alive && unit.position == {row, col} end)
    end)
  end

  def best_path_between({from_row, from_col} = from, to, {units, graph}) do
    other_unit_coords =
      units
      |> Enum.filter(fn unit -> unit.alive end)
      |> Enum.map(fn unit -> unit.position end)

    open_coords = [from | Graph.vertices(graph)] -- other_unit_coords

    weights = %{
      {from_row - 1, from_col} => 0,
      {from_row, from_col - 1} => 1,
      {from_row, from_col + 1} => 2,
      {from_row + 1, from_col} => 3
    }

    graph
    |> Graph.subgraph(open_coords)
    |> Graph.a_star(from, to, fn {row, col} ->
      # Prefer the coordinates in reading order, for the first step.
      Map.get(weights, {row, col}, 0)
    end)
  end

  defp get_first_move_by_reading_order({_, paths}) do
    {_, paths} =
      paths
      |> Enum.group_by(fn path -> Enum.reverse(path) |> hd end)
      |> Enum.sort_by(fn {coord, _} -> coord end)
      |> hd

    paths
    |> Enum.map(&tl/1)
    |> Enum.map(&hd/1)
    |> Enum.min()
  end

  defp find_enemies(unit, units) do
    Enum.filter(units, fn other -> other.alive && other.type != unit.type end)
  end

  def parse_input(input, power \\ %{"G" => 3, "E" => 3}) do
    {units, coords, _row} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({[], Graph.new(), 1}, fn row, acc -> parse_row(row, acc, power) end)

    {sort_units(units), coords}
  end

  defp parse_row(row, {units, graph, row_num}, power) do
    {units, coords, _col_num} =
      row
      |> String.graphemes()
      |> Enum.reduce({units, graph, 1}, fn char, {units, graph, col_num} ->
        units = parse_unit(char, units, power, row_num, col_num)
        graph = parse_coord(char, graph, row_num, col_num)
        {units, graph, col_num + 1}
      end)

    {units, coords, row_num + 1}
  end

  defp sort_units(units) do
    Enum.sort_by(units, fn unit -> unit.position end)
  end

  defp parse_unit("#", units, _, _, _), do: units
  defp parse_unit(".", units, _, _, _), do: units

  defp parse_unit(unit, units, power, row, col) do
    [
      %Unit{
        type: unit,
        hp: 200,
        position: {row, col},
        alive: true,
        power: power[unit]
      }
      | units
    ]
  end

  defp parse_coord("#", graph, _, _), do: graph

  defp parse_coord(_, graph, row, col) do
    graph = Graph.add_vertex(graph, {row, col})

    [{row - 1, col}, {row, col - 1}]
    |> Enum.reduce(graph, fn neighbour, graph ->
      if Graph.has_vertex?(graph, neighbour) do
        graph
        |> Graph.add_edge({row, col}, neighbour)
        |> Graph.add_edge(neighbour, {row, col})
      else
        graph
      end
    end)
  end

  def display_grid({units, graph}) do
    for row <- 1..35, col <- 1..35 do
      if unit = Enum.find(units, fn unit -> unit.position == {row, col} end) do
        unit.type
      else
        if Graph.has_vertex?(graph, {row, col}), do: ".", else: "#"
      end
    end
    |> Enum.chunk_every(35)
    |> Enum.map(&List.to_string/1)
    |> Enum.map(&IO.puts/1)

    units
    |> Enum.each(fn unit ->
      IO.puts("#{unit.type}: HP #{unit.hp}")
    end)
  end

  def bench do
    Benchee.run(
      %{
        "day 15, part 1" => fn -> Advent.data(15) |> Day15.part1() end,
        "day 15, part 2" => fn -> Advent.data(15) |> Day15.part2() end
      },
      Application.get_env(:advent, :benchee)
    )

    :ok
  end
end
