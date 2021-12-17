defmodule Aoc2021.Day12Test do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day12

  alias Aoc2021.Day12

  test "part 1 solution should be correct with test data" do
    assert Day12.solve_part1("priv/day12/test-input-1.txt") == 10
    assert Day12.solve_part1("priv/day12/test-input-2.txt") == 19
    assert Day12.solve_part1("priv/day12/test-input-3.txt") == 226
  end

  test "part 1 solution should be correct" do
    assert Day12.solve_part1() == 3802
  end

  test "part 2 solution should be correct with test data" do
    assert Day12.solve_part2("priv/day12/test-input-1.txt") == 36
    assert Day12.solve_part2("priv/day12/test-input-2.txt") == 103
    assert Day12.solve_part2("priv/day12/test-input-3.txt") == 3509
  end

  @tag timeout: 5_000
  test "part 2 solution should be correct" do
    assert Day12.solve_part2() == 99_448
  end
end
