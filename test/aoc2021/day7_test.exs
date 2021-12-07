defmodule Aoc2021.Day7Test do
  use ExUnit.Case
  doctest Aoc2021.Day7

  alias Aoc2021.Day7

  test "part 1 solution should be correct with test data" do
    assert Day7.solve_part1("priv/day7/test-input.txt") == 37
  end

  test "part 1 solution should be correct" do
    assert Day7.solve_part1("priv/day7/input.txt") == 329_389
  end

  # test "part 1 solution should be correct" do
  #   assert Day7.solve_part1("priv/day7/input.txt") == 358_214
  # end

  # test "part 2 solution should be correct with test data" do
  #   assert Day7.solve_part2("priv/day7/test-input.txt") == 26_984_457_539
  # end

  # test "part 2 solution should be correct" do
  #   assert Day7.solve_part2("priv/day7/input.txt") == 1_622_533_344_325
  # end
end
