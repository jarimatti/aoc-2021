defmodule Aoc2021.Day2Test do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day2

  test "part 1 produces correct result" do
    assert Aoc2021.Day2.solve_part1() == 2_036_120
  end

  test "part 2 produces correct result" do
    assert Aoc2021.Day2.solve_part2() == 2_015_547_716
  end
end
