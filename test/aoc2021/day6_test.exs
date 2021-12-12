defmodule Aoc2021.Day6Test do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day6

  alias Aoc2021.Day6

  test "part 1 solution should be correct with test data" do
    assert Day6.solve_part1("priv/day6/test-input.txt") == 5934
  end

  test "part 1 solution should be correct" do
    assert Day6.solve_part1("priv/day6/input.txt") == 358_214
  end

  test "part 2 solution should be correct with test data" do
    assert Day6.solve_part2("priv/day6/test-input.txt") == 26_984_457_539
  end

  test "part 2 solution should be correct" do
    assert Day6.solve_part2("priv/day6/input.txt") == 1_622_533_344_325
  end

  test "parts 1 and 2 are solved using linear algebra and NX" do
    assert Day6.LinAlg.solve() == {358_214, 1_622_533_344_325}
  end
end
