defmodule Aoc2021.Day13Test do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day13

  alias Aoc2021.Day13

  test "part 1 solution should be correct with test data" do
    assert Day13.solve_part1("priv/day13/test-input.txt") == 17
  end

  @tag :pending
  test "part 1 solution should be correct" do
    assert Day13.solve_part1() == -1
  end

  @tag :pending
  test "part 2 solution should be correct with test data" do
    assert Day13.solve_part2("priv/day13/test-input.txt") == -1
  end

  @tag :pending
  test "part 2 solution should be correct" do
    assert Day13.solve_part2() == -1
  end
end
