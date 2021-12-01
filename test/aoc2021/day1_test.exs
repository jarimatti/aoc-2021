defmodule Aoc2021.Day1Test do
  use ExUnit.Case
  doctest Aoc2021.Day1

  test "increment count produces 7 for part 1 example" do
    input = [
      199,
      200,
      208,
      210,
      200,
      207,
      240,
      269,
      260,
      263
    ]

    assert Aoc2021.Day1.count_increments(input) == 7
  end

  test "part 1 solution is correct" do
    assert Aoc2021.Day1.solve_part1() == 1791
  end

  test "part 2 solution is correct" do
    assert Aoc2021.Day1.solve_part2() == 1822
  end
end
