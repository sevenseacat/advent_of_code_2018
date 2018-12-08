defmodule Day8 do
  @doc """
  iex> Day8.part1("0 3 0 1 2")
  3

  iex> Day8.part1("1 3 0 1 55 0 1 2")
  58

  iex> Day8.part1("2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2")
  138
  """
  def part1(input) do
    input
    |> parse_input
    |> sum_metadata
  end

  @doc """
  iex> Day8.part2("2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2")
  66
  """
  def part2(input) do
    input
    |> parse_input
  end

  defp sum_metadata(%{metadata: metadata, children: children}) do
    Enum.sum(Enum.map(children, &sum_metadata/1)) + Enum.sum(metadata)
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> read_nodes([])
    |> Enum.at(1)
    |> hd
  end

  defp read_nodes([], acc), do: acc

  defp read_nodes(input, acc) do
    {node, rest} = read_node(input)
    [rest, [node | acc]]
  end

  defp read_node([children_count, metadata_count | rest]) do
    {rest, children} =
      if children_count > 0 do
        1..children_count
        |> Enum.to_list()
        |> Enum.reduce({rest, []}, fn _index, {new_rest, children} ->
          {node, rest} = read_node(new_rest)
          {rest, [node | children]}
        end)
      else
        {rest, []}
      end

    {metadata, rest} = Enum.split(rest, metadata_count)
    {%{children: children, metadata: metadata}, rest}
  end

  def bench do
    Benchee.run(
      %{
        "day 8, part 1" => fn -> Advent.data(8) |> part1() end
      },
      Application.get_env(:advent, :benchee)
    )

    :ok
  end
end
