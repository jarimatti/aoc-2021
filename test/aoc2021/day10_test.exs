defmodule Aoc2021.Day10Test do
  use ExUnit.Case
  doctest Aoc2021.Day10

  alias Aoc2021.Day10

  test "part 1 solution should be correct with test data" do
    assert Day10.solve_part1("priv/day10/test-input.txt") == 26_397
  end

  test "part 1 solution should be correct" do
    assert Day10.solve_part1() == 462_693
  end

  @tag :pending
  test "part 2 solution should be correct with test data" do
    assert Day10.solve_part2("priv/day10/test-input.txt") == -1
  end

  @tag :pending
  test "part 2 solution should be correct" do
    assert Day10.solve_part2() == -1
  end
end
