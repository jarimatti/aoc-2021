defmodule Aoc2021.Day10Test do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day10

  alias Aoc2021.Day10

  test "part 1 solution should be correct with test data" do
    assert Day10.solve_part1("priv/day10/test-input.txt") == 26_397
  end

  test "part 1 solution should be correct" do
    assert Day10.solve_part1() == 462_693
  end

  test "part 2 solution should be correct with test data" do
    assert Day10.solve_part2("priv/day10/test-input.txt") == 288_957
  end

  test "part 2 solution should be correct" do
    assert Day10.solve_part2() == 3_094_671_161
  end
end
