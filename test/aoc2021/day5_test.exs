defmodule Aoc2021.Day5Test do
  use ExUnit.Case
  doctest Aoc2021.Day5

  alias Aoc2021.Day5

  test "part 1 solution should be correct with test data" do
    assert Day5.solve_part1("priv/day5/test-input.txt") == 5
  end
end
