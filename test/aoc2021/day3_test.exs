defmodule Aoc2021.Day3Test do
  use ExUnit.Case
  doctest Aoc2021.Day3

  alias Aoc2021.Day3

  test "part 1 solution should be correct" do
    assert Day3.solve_part1() == 3_687_446
  end
end
