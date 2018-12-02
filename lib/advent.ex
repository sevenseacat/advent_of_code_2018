defmodule Advent do
  def data(day_no, opts \\ []) do
    filename = if opts[:test], do: "test/data/day_#{day_no}", else: "lib/data/day_#{day_no}"

    data = File.read!(filename)

    if opts[:parse], do: apply(:"Elixir.Day#{day_no}", :parse_input, [data]), else: data
  end

  def run_all do
    [
      {1, 1, fn -> data(1) |> Day1.part1() end},
      {1, 2, fn -> data(1) |> Day1.part2() end},
      {2, 1, fn -> data(2) |> String.split("\n") |> Day2.part1() end}
    ]
    |> Enum.each(fn {day, part_no, fun} ->
      IO.puts("day #{day}, part #{part_no}: #{Benchmark.measure(fun) |> elem(0)}")
    end)
  end
end
