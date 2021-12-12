defmodule Aoc2021.Day4Test do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day4

  alias Aoc2021.Day4

  test "part 1 solution should be correct with test data" do
    assert Day4.solve_part1("priv/day4/test-input.txt") == 4_512
  end

  test "part 1 solution should be correct with data" do
    assert Day4.solve_part1() == 51_776
  end

  test "part 2 solution should be correct with test data" do
    assert Day4.solve_part2("priv/day4/test-input.txt") == 1_924
  end
end
