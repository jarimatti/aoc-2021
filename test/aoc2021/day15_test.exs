defmodule Aoc2021.Day15Test do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day15

  alias Aoc2021.Day15

  test "part 1 solution should be correct with test data" do
    assert Day15.solve_part1("priv/day15/test-input.txt") == 40
  end

  @tag timeout: 5_000
  test "part 1 solution should be correct" do
    assert Day15.solve_part1() == 656
  end

  @tag :pending
  test "part 2 solution should be correct with test data" do
    assert Day15.solve_part2("priv/day15/test-input.txt") == -1
  end

  @tag :pending
  test "part 2 solution should be correct" do
    assert Day15.solve_part2() == -1
  end
end
