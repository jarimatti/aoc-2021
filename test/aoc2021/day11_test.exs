defmodule Aoc2021.Day11Test do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day11

  alias Aoc2021.Day11

  test "part 1 solution should be correct with test data" do
    assert Day11.solve_part1("priv/day11/test-input.txt") == 1656
  end

  test "part 1 solution should be correct" do
    assert Day11.solve_part1() == 1719
  end

  @tag :pending
  test "part 2 solution should be correct with test data" do
    assert Day11.solve_part2("priv/day11/test-input.txt") == -1
  end

  @tag :pending
  test "part 2 solution should be correct" do
    assert Day11.solve_part2() == -1
  end
end
