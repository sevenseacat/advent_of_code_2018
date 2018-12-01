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
end
