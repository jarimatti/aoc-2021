defmodule Aoc2021.Day9Test do
  use ExUnit.Case
  doctest Aoc2021.Day9

  alias Aoc2021.Day9

  test "part 1 solution should be correct with test data" do
    assert Day9.solve_part1("priv/day9/test-input.txt") == 15
  end

  @tag :pending
  test "part 1 solution should be correct" do
    assert Day9.solve_part1() == -1
  end

  @tag :pending
  test "part 2 solution should be correct with test data" do
    assert Day9.solve_part2("priv/day9/test-input.txt") == -1
  end

  @tag :pending
  test "part 2 solution should be correct" do
    assert Day9.solve_part2() == -1
  end
end
