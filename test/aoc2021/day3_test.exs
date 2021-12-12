defmodule Aoc2021.Day3Test do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day3

  alias Aoc2021.Day3

  test "part 1 solution should be correct" do
    assert Day3.solve_part1() == 3_687_446
  end

  test "part 2 solution should be correct" do
    assert Day3.solve_part2() == 4_406_844
  end
end
