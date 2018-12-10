defmodule Day10 do
  def part1(input, time \\ 3) do
    input
    |> parse_input
    |> run_time(0, time)
  end

  defp run_time(_, time, time), do: nil

  defp run_time(input, time, max) do
    input
    |> show_graph(time)
    |> Enum.map(&move/1)
    |> run_time(time + 1, max)
  end

  # Used to see the full output.
  defp show_graph(input, time) do
    if time > 10075 do
      IO.puts("-------- #{time} ---------")

      for j <- 160..180 do
        for i <- 140..210 do
          case(Enum.find(input, fn {x, y, _, _} -> x == i && j == y end)) do
            nil -> "."
            _ -> "#"
          end
        end
        |> Enum.join()
        |> IO.puts()
      end
    end

    input
  end

  defp move({x, y, x_acc, y_acc}), do: {x + x_acc, y + y_acc, x_acc, y_acc}

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    [_, x, y, x_acc, y_acc, _] = String.split(row, ["position=<", ", ", "> velocity=<", ">"])

    {parse_digit(x), parse_digit(y), parse_digit(x_acc), parse_digit(y_acc)}
  end

  defp parse_digit(digit) do
    digit
    |> String.trim()
    |> String.to_integer()
  end

  def bench do
    Benchee.run(
      %{
        "day 10, both parts" => fn -> File.read!("lib/data/day_10") |> Day10.part1(10077) end
      },
      Application.get_env(:advent, :benchee)
    )

    :ok
  end
end
