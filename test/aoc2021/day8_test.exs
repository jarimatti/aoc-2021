defmodule Aoc2021.Day8Test do
  use ExUnit.Case
  doctest Aoc2021.Day8

  alias Aoc2021.Day8

  test "part 1 solution should be correct with test data" do
    assert Day8.solve_part1("priv/day8/test-input.txt") == 26
  end

  test "part 1 solution should be correct" do
    assert Day8.solve_part1() == 365
  end

  test "part 2 solution should be correct with test data" do
    assert Day8.solve_part2("priv/day8/test-input.txt") == 61_229
  end

  test "part 2 solution should be correct" do
    assert Day8.solve_part2() == 975_706
  end
end
