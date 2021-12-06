defmodule Aoc2021.Day6Test do
  use ExUnit.Case
  doctest Aoc2021.Day6

  alias Aoc2021.Day6

  test "part 1 solution should be correct with test data" do
    assert Day6.solve_part1("priv/day6/test-input.txt") == 5934
  end
end
