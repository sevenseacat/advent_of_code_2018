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
  doctest Day13

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

  describe "day 13, parse input" do
    test "it parses simple loops" do
      {:ok, input} = File.read("test/data/day_13_simple_loop")

      expected_output = %{
        {0, 0} => {"/", nil},
        {1, 0} => {"-", nil},
        {2, 0} => {"-", nil},
        {3, 0} => {"-", nil},
        {4, 0} => {"\\", nil},
        {0, 1} => {"|", nil},
        {4, 1} => {"|", nil},
        {0, 2} => {"\\", nil},
        {1, 2} => {"-", nil},
        {2, 2} => {"-", nil},
        {3, 2} => {"-", nil},
        {4, 2} => {"/", nil}
      }

      assert Day13.parse_input(input) == expected_output
    end

    test "it can parse intersections and carts" do
      {:ok, input} = File.read("test/data/day_13_intersections_carts")

      expected_output = %{
        {0, 0} => {"/", nil},
        {1, 0} => {"-", nil},
        {2, 0} => {"-", nil},
        {3, 0} => {"-", :right},
        {4, 0} => {"-", nil},
        {5, 0} => {"-", nil},
        {6, 0} => {"\\", nil},
        {0, 1} => {"|", nil},
        {6, 1} => {"|", nil},
        {0, 2} => {"|", nil},
        {3, 2} => {"/", nil},
        {4, 2} => {"-", nil},
        {5, 2} => {"-", nil},
        {6, 2} => {"+", nil},
        {7, 2} => {"-", nil},
        {8, 2} => {"-", nil},
        {9, 2} => {"\\", nil},
        {0, 3} => {"|", nil},
        {3, 3} => {"|", :up},
        {6, 3} => {"|", nil},
        {9, 3} => {"|", nil},
        {0, 4} => {"\\", nil},
        {1, 4} => {"-", nil},
        {2, 4} => {"-", nil},
        {3, 4} => {"+", nil},
        {4, 4} => {"-", nil},
        {5, 4} => {"-", nil},
        {6, 4} => {"/", nil},
        {9, 4} => {"|", nil},
        {3, 5} => {"|", nil},
        {9, 5} => {"|", nil},
        {3, 6} => {"\\", nil},
        {4, 6} => {"-", nil},
        {5, 6} => {"-", nil},
        {6, 6} => {"-", nil},
        {7, 6} => {"-", nil},
        {8, 6} => {"-", nil},
        {9, 6} => {"/", nil}
      }

      assert Day13.parse_input(input) == expected_output
    end
  end
end
