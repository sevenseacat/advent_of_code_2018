defmodule Advent do
  def data(day), do: File.read!("lib/data/day_#{day}")

  # Extra big data inputs for day 2, to see how our algorithms perform.
  # https://www.reddit.com/r/adventofcode/comments/a2rt9s/2018_day_2_part_2_here_are_some_big_inputs_to/
  # Spoilers - Poorly.
  def day_2_extra(file) do
    IO.puts(
      "#{file}: #{
        Benchmark.measure(fn ->
          File.read!("lib/data/day_2_extra/#{file}.txt") |> Day2.parse_input() |> Day2.part2()
        end)
        |> elem(0)
      }"
    )
  end
end
