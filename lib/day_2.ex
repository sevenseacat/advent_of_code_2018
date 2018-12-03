defmodule Day2 do
  @doc """
  iex> Day2.part1(["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"])
  {4, 3}
  """
  def part1(input), do: do_part1(input, {0, 0})

  def do_part1([], result), do: result

  def do_part1([string | rest], {doubles, triples}) do
    do_part1(
      rest,
      {
        inc_if_true(doubles, has_letter_count?(string, 2)),
        inc_if_true(triples, has_letter_count?(string, 3))
      }
    )
  end

  def inc_if_true(val, false), do: val
  def inc_if_true(val, true), do: val + 1

  @doc """
  iex> Day2.part2(["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"])
  "fgij"
  """
  def part2([head | tail]) do
    case check_against_rest(head, tail) do
      nil -> part2(tail)
      value -> value
    end
  end

  def check_against_rest(_, []), do: nil

  def check_against_rest(subject, [possible | rest]) do
    # Calculate hamming distance between subject and possible - if 1, then these strings are the ones we want.
    if hamming(subject, possible) == 1 do
      remove_different_letters(subject, possible)
    else
      check_against_rest(subject, rest)
    end
  end

  @doc """
  iex> Day2.hamming("abcde", "axcye")
  2

  iex> Day2.hamming("fghij", "fguij")
  1
  """
  def hamming(str1, str2) do
    do_hamming(String.graphemes(str1), String.graphemes(str2), 0)
  end

  defp do_hamming([h1 | t1], [h2 | t2], acc) do
    do_hamming(t1, t2, inc_if_true(acc, h1 != h2))
  end

  defp do_hamming([], [], acc), do: acc

  def remove_different_letters(str1, str2) do
    do_removal(String.graphemes(str1), String.graphemes(str2), [])
  end

  def do_removal([], [], val) do
    val
    |> Enum.reverse()
    |> List.to_string()
  end

  def do_removal([a | as], [a | bs], val), do: do_removal(as, bs, [a | val])
  def do_removal([_ | as], [_ | bs], val), do: do_removal(as, bs, val)

  @doc """
  iex> Day2.has_letter_count?("abcdef", 2)
  false

  iex> Day2.has_letter_count?("bababc", 2)
  true

  iex> Day2.has_letter_count?("abbcde", 2)
  true

  iex> Day2.has_letter_count?("abcccd", 2)
  false

  iex> Day2.has_letter_count?("abcdef", 3)
  false

  iex> Day2.has_letter_count?("bababc", 3)
  true

  iex> Day2.has_letter_count?("abbcde", 3)
  false

  iex> Day2.has_letter_count?("abcccd", 3)
  true
  """
  def has_letter_count?(string, count) do
    letter =
      string
      |> String.graphemes()
      |> frequencies
      |> Enum.find(fn {_, v} -> v == count end)

    letter != nil
  end

  # https://www.rosettacode.org/wiki/Letter_frequency#Elixir
  defp frequencies(string) do
    Enum.reduce(string, Map.new(), fn c, acc -> Map.update(acc, c, 1, &(&1 + 1)) end)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
  end
end
