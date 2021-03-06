defmodule AdventTest do
  use ExUnit.Case
  doctest Advent
  doctest Day1
  doctest Day2
  doctest Day3
  doctest Day4
  doctest Day5
  doctest Day6
  doctest Day7
  doctest Day8
  doctest Day9
  doctest Day10
  doctest Day11
  doctest Day12
  doctest Day14
  doctest Day16
  doctest Day18
  doctest Day20
  doctest Day22
  doctest Day23

  describe "day 7, #tick" do
    test "it performs the first tick with sample input" do
      result =
        Day7.tick(%{
          todo: %{
            "A" => ["C"],
            "B" => ["A"],
            "C" => [],
            "D" => ["A"],
            "E" => ["F", "D", "B"],
            "F" => ["C"]
          },
          workers: [%{doing: nil, wait: 0}, %{doing: nil, wait: 0}],
          time: 0,
          done: [],
          delay: 0
        })

      assert result == %{
               todo: %{
                 "A" => ["C"],
                 "B" => ["A"],
                 "D" => ["A"],
                 "E" => ["F", "D", "B"],
                 "F" => ["C"]
               },
               workers: [%{doing: "C", wait: 3}, %{doing: nil, wait: 0}],
               time: 1,
               done: [],
               delay: 0
             }
    end

    test "it performs the second tick with sample input" do
      result =
        Day7.tick(%{
          todo: %{
            "A" => ["C"],
            "B" => ["A"],
            "D" => ["A"],
            "E" => ["F", "D", "B"],
            "F" => ["C"]
          },
          workers: [%{doing: "C", wait: 3}, %{doing: nil, wait: 0}],
          time: 1,
          done: [],
          delay: 0
        })

      assert result == %{
               todo: %{
                 "A" => ["C"],
                 "B" => ["A"],
                 "D" => ["A"],
                 "E" => ["F", "D", "B"],
                 "F" => ["C"]
               },
               workers: [%{doing: "C", wait: 2}, %{doing: nil, wait: 0}],
               time: 2,
               done: [],
               delay: 0
             }
    end

    test "it performs the third tick with sample input" do
      result =
        Day7.tick(%{
          todo: %{
            "A" => ["C"],
            "B" => ["A"],
            "D" => ["A"],
            "E" => ["F", "D", "B"],
            "F" => ["C"]
          },
          workers: [%{doing: "C", wait: 2}, %{doing: nil, wait: 0}],
          time: 2,
          done: [],
          delay: 0
        })

      assert result == %{
               todo: %{
                 "A" => ["C"],
                 "B" => ["A"],
                 "D" => ["A"],
                 "E" => ["F", "D", "B"],
                 "F" => ["C"]
               },
               workers: [%{doing: "C", wait: 1}, %{doing: nil, wait: 0}],
               time: 3,
               done: [],
               delay: 0
             }
    end

    test "it performs the fourth tick with sample input" do
      result =
        Day7.tick(%{
          todo: %{
            "A" => ["C"],
            "B" => ["A"],
            "D" => ["A"],
            "E" => ["F", "D", "B"],
            "F" => ["C"]
          },
          workers: [%{doing: "C", wait: 1}, %{doing: nil, wait: 0}],
          time: 3,
          done: [],
          delay: 0
        })

      assert result == %{
               todo: %{
                 "B" => ["A"],
                 "D" => ["A"],
                 "E" => ["F", "D", "B"]
               },
               workers: [%{doing: "A", wait: 1}, %{doing: "F", wait: 6}],
               time: 4,
               done: ["C"],
               delay: 0
             }
    end

    test "it performs the fifth tick with sample input" do
      result =
        Day7.tick(%{
          todo: %{
            "B" => [],
            "D" => [],
            "E" => ["F", "D", "B"],
            "F" => []
          },
          workers: [%{doing: "A", wait: 1}, %{doing: "F", wait: 6}],
          time: 4,
          done: ["C"],
          delay: 0
        })

      assert result == %{
               todo: %{
                 "D" => [],
                 "E" => ["F", "D", "B"],
                 "F" => []
               },
               workers: [%{doing: "B", wait: 2}, %{doing: "F", wait: 5}],
               time: 5,
               done: ["A", "C"],
               delay: 0
             }
    end
  end

  describe "day 12" do
    test "part 1 works for sample input" do
      initial = "#..#.#..##......###...###"

      rules =
        "...## => #\n..#.. => #\n.#... => #\n.#.#. => #\n.#.## => #\n.##.. => #\n.#### => #\n#.#.# => #\n#.### => #\n##.#. => #\n##.## => #\n###.. => #\n###.# => #\n####. => #"

      assert Day12.part1(initial, rules, 0) == 145

      assert Day12.part1(initial, rules, 1) == 91

      assert Day12.part1(initial, rules, 20) == 325
    end

    test "parsing input" do
      input =
        "...## => #\n..#.. => #\n.#... => #\n.#.#. => #\n.#.## => #\n.##.. => #\n.#### => #\n#.#.# => #\n#.### => #\n##.#. => #\n##.## => #\n###.. => #\n###.# => #\n####. => #"

      output = [
        {[?., ?., ?., ?#, ?#], ?#},
        {[?., ?., ?#, ?., ?.], ?#},
        {[?., ?#, ?., ?., ?.], ?#},
        {[?., ?#, ?., ?#, ?.], ?#},
        {[?., ?#, ?., ?#, ?#], ?#},
        {[?., ?#, ?#, ?., ?.], ?#},
        {[?., ?#, ?#, ?#, ?#], ?#},
        {[?#, ?., ?#, ?., ?#], ?#},
        {[?#, ?., ?#, ?#, ?#], ?#},
        {[?#, ?#, ?., ?#, ?.], ?#},
        {[?#, ?#, ?., ?#, ?#], ?#},
        {[?#, ?#, ?#, ?., ?.], ?#},
        {[?#, ?#, ?#, ?., ?#], ?#},
        {[?#, ?#, ?#, ?#, ?.], ?#}
      ]

      assert Day12.parse_input(input) == output
    end
  end
end
