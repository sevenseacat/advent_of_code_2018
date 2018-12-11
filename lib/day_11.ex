# This wouldn't have been possible without Reddit and the hint that I wanted to use a summed-area table.
# https://en.wikipedia.org/wiki/Summed-area_table
# Well, it would have been, but my naive implementation literally took hours to come up with an answer.
# This takes a few seconds.
defmodule Day11 do
  @serial 7400
  @max_size 300

  @doc """
  iex> Day11.part1(18)
  {{33, 45, 3}, 29}

  iex> Day11.part1(42)
  {{21, 61, 3}, 30}
  """
  def part1(serial \\ @serial) do
    max_by_summed_area_table(serial, 3, 3)
  end

  @doc """
  iex> Day11.part2(18)
  {{90,269,16}, 113}

  iex> Day11.part2(42)
  {{232,251,12}, 119}
  """
  def part2(serial \\ @serial) do
    max_by_summed_area_table(serial, 1, @max_size)
  end

  @doc """
  iex> Day11.cell_power({3, 5}, 8)
  4

  iex> Day11.cell_power({122, 79}, 57)
  -5

  iex> Day11.cell_power({217, 196}, 39)
  0

  iex> Day11.cell_power({101, 153}, 71)
  4
  """
  def cell_power({x, y}, serial) do
    rack_id = x + 10
    power_level = (rack_id * y + serial) * rack_id

    power_level
    |> div(100)
    |> rem(10)
    |> Kernel.-(5)
  end

  defp max_by_summed_area_table(serial, min_size, max_size) do
    table = generate_summed_area_table(serial)

    min_size..max_size
    |> Enum.map(fn size -> max_grid_by_size(table, size) end)
    |> Enum.max_by(fn {_, power} -> power end)
  end

  defp generate_summed_area_table(serial) do
    table = :ets.new(:day11, [:set])

    Enum.each(@max_size..1, fn x ->
      Enum.each(@max_size..1, fn y ->
        :ets.insert(
          table,
          {{x, y},
           cell_power({x, y}, serial) + ets_lookup(table, {x + 1, y}) +
             ets_lookup(table, {x, y + 1}) - ets_lookup(table, {x + 1, y + 1})}
        )
      end)
    end)

    table
  end

  defp ets_lookup(table, {x, y}) do
    case :ets.lookup(table, {x, y}) do
      [{_coord, val}] -> val
      _ -> 0
    end
  end

  defp max_grid_by_size(table, size) do
    for x <- 1..(@max_size - size + 1), y <- 1..(@max_size - size + 1) do
      # The magic of the summed-area table at work. A + D - B - C.
      {{x, y, size},
       ets_lookup(table, {x, y}) + ets_lookup(table, {x + size, y + size}) -
         ets_lookup(table, {x, y + size}) - ets_lookup(table, {x + size, y})}
    end
    |> Enum.max_by(fn {_, power} -> power end)
  end

  def bench do
    Benchee.run(
      %{
        "day 11, part 1" => fn -> Day11.part1() end,
        "day 11, part 2" => fn -> Day11.part2() end
      },
      Application.get_env(:advent, :benchee)
    )

    :ok
  end
end
