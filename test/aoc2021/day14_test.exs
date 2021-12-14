defmodule Aoc2021.Day14Test do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day14

  alias Aoc2021.Day14

  test "part 1 solution should be correct with test data" do
    assert Day14.solve_part1("priv/day14/test-input.txt") == 1588
  end

  test "part 1 step works" do
    {s, map} = Day14.Reader.read_input("priv/day14/test-input.txt")

    s = Day14.step(s, map)
    assert s == 'NCNBCHB'

    s = Day14.step(s, map)
    assert s == 'NBCCNBBBCBHCB'

    s = Day14.step(s, map)
    assert s == 'NBBBCNCCNBBNBNBBCHBHHBCHB'

    s = Day14.step(s, map)
    assert s == 'NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB'
  end

  test "part 1 solution should be correct" do
    assert Day14.solve_part1() == 3697
  end

  @tag :pending
  test "part 2 solution should be correct with test data" do
    assert Day14.solve_part2("priv/day14/test-input.txt") == -1
  end

  @tag :pending
  test "part 2 solution should be correct" do
    assert Day14.solve_part2() == -1
  end
end
