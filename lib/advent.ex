defmodule Advent do
  def data(day_no, opts \\ []) do
    filename = if opts[:test], do: "test/data/day_#{day_no}", else: "lib/data/day_#{day_no}"

    data = File.read!(filename)

    if opts[:parse], do: apply(:"Elixir.Day#{day_no}", :parse_input, [data]), else: data
  end

  def run_all do
    benchee_opts = [
      print: [benchmarking: false, configuration: false],
      console: [comparison: false]
    ]

    Benchee.run(
      %{
        "day 1, part 1" => fn -> data(1) |> Day1.part1() end,
        "day 1, part 2" => fn -> data(1) |> Day1.part2() end
      },
      benchee_opts
    )

    Benchee.run(
      %{
        "day 2, part 1" => fn -> data(2, parse: true) |> Day2.part1() end,
        "day 2, part 2" => fn -> data(2, parse: true) |> Day2.part2() end
      },
      benchee_opts
    )

    Benchee.run(
      %{
        "day 3, part 1" => fn -> data(3) |> Day3.part1() end,
        "day 3, part 2" => fn -> data(3) |> Day3.part2() end
      },
      benchee_opts
    )

    Benchee.run(
      %{
        "day 4, part 1" => fn -> data(4, parse: true) |> Day4.part1() end,
        "day 4, part 2" => fn -> data(4, parse: true) |> Day4.part2() end
      },
      benchee_opts
    )

    Benchee.run(
      %{
        "day 5, part 1" => fn -> data(5) |> Day5.part1() |> String.length() end,
        "day 5, part 2" => fn -> data(5) |> Day5.part2() end
      },
      benchee_opts
    )

    IO.puts("Done")
  end

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
