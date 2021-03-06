defmodule Day1 do
  @doc """
  iex> Day1.part1("+1\\n+1\\n+1")
  3

  iex> Day1.part1("+1\\n+1\\n-2")
  0

  iex> Day1.part1("-1\\n-2\\n-3")
  -6
  """
  def part1(data) do
    data
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  @doc """
  iex> Day1.part2("+1\\n-1")
  0

  iex> Day1.part2("+3\\n+3\\n+4\\n-2\\n-4")
  10

  iex> Day1.part2("-6\\n+3\\n+8\\n+5\\n-6")
  5

  iex> Day1.part2("+7\\n+7\\n-2\\n-7\\n-4")
  14
  """
  def part2(data) do
    list = String.split(data)
    do_part2(list, 0, list, MapSet.new())
  end

  def do_part2([], current, original, seen), do: do_part2(original, current, original, seen)

  def do_part2([<<sign::binary-1, val::binary>> | rest], current, original, seen) do
    if MapSet.member?(seen, current) do
      current
    else
      new = apply(Kernel, String.to_atom(sign), [current, String.to_integer(val)])
      do_part2(rest, new, original, MapSet.put(seen, current))
    end
  end

  def bench do
    Benchee.run(
      %{
        "day 1, part 1" => fn -> Advent.data(1) |> part1() end,
        "day 1, part 2" => fn -> Advent.data(1) |> part2() end
      },
      Application.get_env(:advent, :benchee)
    )

    :ok
  end
end
