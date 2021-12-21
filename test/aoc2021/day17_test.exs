defmodule Aoc2021.Day17Test do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day17

  alias Aoc2021.Day17

  test "maximum y for example" do
    assert Day17.max_y(-10..-5) == 45
  end

  test "maximum height given initial velocity" do
    assert Day17.max_height(9) == 45
    assert Day17.max_height(2) == 3
    assert Day17.max_height(3) == 6
  end

  test "part 1 solution should be correct with test data" do
    assert Day17.solve_part1("priv/day17/test-input.txt") == 45
  end

  test "part 1 solution should be correct" do
    assert Day17.solve_part1() == 15_400
  end

  @tag :pending
  test "part 2 solution should be correct with test data" do
    assert Day17.solve_part2("priv/day17/test-input.txt") == -1
  end

  @tag :pending
  test "part 2 solution should be correct" do
    assert Day17.solve_part2() == -1
  end
end
