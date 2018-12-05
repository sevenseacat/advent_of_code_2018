defmodule Day5 do
  @doc """
  iex> Day5.part1("aA")
  ""

  iex> Day5.part1("abBA")
  ""

  iex> Day5.part1("abAB")
  "abAB"

  iex> Day5.part1("aabAAB")
  "aabAAB"

  iex> Day5.part1("dabAcCaCBAcCcaDA")
  "dabCBAcaDA"

  iex> Day5.part1("dabAcCaCBAcCcadDAC")
  "dabCBA"
  """
  def part1(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> dedup([])
    |> List.to_string()
  end

  @doc """
  iex> Day5.part2("dabAcCaCBAcCcaDA")
  {"c", 4}
  """
  def part2(input) do
    input = String.trim(input)
    input_list = String.graphemes(input)

    input
    |> String.downcase()
    |> String.graphemes()
    |> Enum.uniq()
    |> Enum.map(fn char ->
      {char, remove_letter_and_dedup(input_list, char) |> length}
    end)
    |> Enum.min_by(fn {_, result} -> result end)
  end

  @doc """
  iex> Day5.remove_letter_and_dedup(String.graphemes("dabAcCaCBAcCcaDA"), "a") |> List.to_string
  "dbCBcD"

  iex> Day5.remove_letter_and_dedup(String.graphemes("dabAcCaCBAcCcaDA"), "b") |> List.to_string
  "daCAcaDA"

  iex> Day5.remove_letter_and_dedup(String.graphemes("dabAcCaCBAcCcaDA"), "c") |> List.to_string
  "daDA"

  iex> Day5.remove_letter_and_dedup(String.graphemes("dabAcCaCBAcCcaDA"), "d") |> List.to_string
  "abCBAc"
  """
  def remove_letter_and_dedup(list, char) do
    list
    |> Enum.reject(&(&1 == char || &1 == String.upcase(char)))
    |> dedup([])
  end

  defp dedup([], seen), do: Enum.reverse(seen)
  defp dedup([x], seen), do: dedup([], [x | seen])

  defp dedup([a, b | rest], seen) do
    if a != b && String.downcase(a) == String.downcase(b) do
      # Edge case for when we're at the start of the list, we don't need to look backwards.
      {new_list, seen} =
        if seen == [] do
          {rest, seen}
        else
          {[hd(seen) | rest], tl(seen)}
        end

      dedup(new_list, seen)
    else
      dedup([b | rest], [a | seen])
    end
  end
end
