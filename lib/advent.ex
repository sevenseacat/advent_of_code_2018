defmodule Advent do
  def data(day_no, opts \\ []) do
    filename = if opts[:test], do: "test/data/day_#{day_no}", else: "lib/data/day_#{day_no}"

    data = File.read!(filename)

    if opts[:parse], do: apply(:"Elixir.Day#{day_no}", :parse_input, [data]), else: data
  end
end
