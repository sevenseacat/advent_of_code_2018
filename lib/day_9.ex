defmodule Day9 do
  @doc """
  iex> Day9.digraph("9 players; last marble is worth 25 points")
  32

  iex> Day9.digraph("10 players; last marble is worth 1618 points")
  8317

  iex> Day9.digraph("13 players; last marble is worth 7999 points")
  146373

  iex> Day9.digraph("17 players; last marble is worth 1104 points")
  2764

  iex> Day9.digraph("21 players; last marble is worth 6111 points")
  54718

  iex> Day9.digraph("30 players; last marble is worth 5807 points")
  37305
  """
  def digraph(input) do
    field = :digraph.new()
    :digraph.add_vertex(field, 0)
    :digraph.add_edge(field, 0, 0)

    do_part1(input, &place_marble/3, field)
  end

  @doc """
  iex> Day9.ziplist("9 players; last marble is worth 25 points")
  32

  iex> Day9.ziplist("10 players; last marble is worth 1618 points")
  8317

  iex> Day9.ziplist("13 players; last marble is worth 7999 points")
  146373

  iex> Day9.ziplist("17 players; last marble is worth 1104 points")
  2764

  iex> Day9.ziplist("21 players; last marble is worth 6111 points")
  54718

  iex> Day9.ziplist("30 players; last marble is worth 5807 points")
  37305
  """
  def ziplist(input) do
    do_part1(input, &place_marble_zip/3, {[0], []})
  end

  defp do_part1(input, fun, field) do
    {players, points} = parse_input(input)

    run_game(
      %{
        scores: %{},
        players: players,
        turn: 1,
        current: 1,
        last: 0,
        max: points,
        field: field
      },
      fun
    )
    |> Map.get(:scores)
    |> Enum.max_by(fn {_player, score} -> score end)
    |> elem(1)
  end

  defp run_game(%{current: marble, max: max} = game, _) when marble > max, do: game

  defp run_game(
         %{
           players: players,
           turn: turn,
           current: curr,
           last: last,
           field: field,
           scores: scores,
           max: max
         },
         fun
       ) do
    {score, new_pos, field} = fun.(field, curr, last)

    run_game(
      %{
        players: players,
        turn: rem(turn + 1, players),
        current: curr + 1,
        last: new_pos,
        field: field,
        scores: Map.update(scores, turn, score, &(&1 + score)),
        max: max
      },
      fun
    )
  end

  defp place_marble_zip(state, new, _) do
    if rem(new, 23) == 0 do
      {fwd, bwd} =
        Enum.reduce(1..7, state, fn _, state ->
          move_marble_back(state)
        end)

      {new + hd(bwd), nil, {tl(fwd), [hd(fwd) | tl(bwd)]}}
    else
      {fwd, bwd} = move_marble_forward(state)
      {0, new, {fwd, [new | bwd]}}
    end
  end

  defp move_marble_back({fwd, []}), do: move_marble_back({[], Enum.reverse(fwd)})
  defp move_marble_back({fwd, [hd | bwd]}), do: {[hd | fwd], bwd}

  defp move_marble_forward({[], bwd}), do: move_marble_forward({Enum.reverse(bwd), []})
  defp move_marble_forward({[hd | fwd], bwd}), do: {fwd, [hd | bwd]}

  defp place_marble(graph, new, last) do
    if rem(new, 23) == 0 do
      first = :digraph.in_neighbours(graph, last) |> hd
      second = :digraph.in_neighbours(graph, first) |> hd
      third = :digraph.in_neighbours(graph, second) |> hd
      fourth = :digraph.in_neighbours(graph, third) |> hd
      fifth = :digraph.in_neighbours(graph, fourth) |> hd
      sixth = :digraph.in_neighbours(graph, fifth) |> hd
      seventh = :digraph.in_neighbours(graph, sixth) |> hd
      eighth = :digraph.in_neighbours(graph, seventh) |> hd

      :digraph.del_path(graph, eighth, seventh)
      :digraph.del_path(graph, seventh, sixth)
      :digraph.del_vertex(graph, seventh)
      :digraph.add_edge(graph, eighth, sixth)

      {new + seventh, sixth, graph}
    else
      :digraph.add_vertex(graph, new)
      first = :digraph.out_neighbours(graph, last) |> hd
      second = :digraph.out_neighbours(graph, first) |> hd
      :digraph.del_path(graph, first, second)
      :digraph.add_edge(graph, first, new)
      :digraph.add_edge(graph, new, second)
      {0, new, graph}
    end
  end

  defp parse_input(input) do
    ~r/(\d+) players; last marble is worth (\d+) points/
    |> Regex.run(input, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def bench do
    Benchee.run(
      %{
        "day 9, part 1 (digraph)" => fn ->
          digraph("429 players; last marble is worth 70901 points")
        end,
        "day 9, part 1 (ziplist)" => fn ->
          ziplist("429 players; last marble is worth 70901 points")
        end,
        "day 9, part 2 (digraph)" => fn ->
          digraph("429 players; last marble is worth 7090100 points")
        end,
        "day 9, part 2 (ziplist)" => fn ->
          ziplist("429 players; last marble is worth 7090100 points")
        end
      },
      Application.get_env(:advent, :benchee)
    )

    :ok
  end
end
