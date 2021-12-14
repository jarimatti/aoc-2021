defmodule Aoc2021.Day14Test do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day14

  alias Aoc2021.Day14

  test "part 1 solution should be correct with test data" do
    assert Day14.solve_part1("priv/day14/test-input.txt") == 1588
  end

  test "part 1 solution should be correct" do
    assert Day14.solve_part1() == 3697
  end

  test "part 2 solution should be correct with test data" do
    assert Day14.solve_part2("priv/day14/test-input.txt") == 2_188_189_693_529
  end

  test "part 2 solution should be correct" do
    assert Day14.solve_part2() == 4_371_307_836_157
  end
end
