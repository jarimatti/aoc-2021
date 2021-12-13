defmodule Aoc2021.Day13Test do
  use ExUnit.Case, async: true

  import ExUnit.CaptureIO

  doctest Aoc2021.Day13

  alias Aoc2021.Day13

  test "part 1 solution should be correct with test data" do
    assert Day13.solve_part1("priv/day13/test-input.txt") == 17
  end

  test "part 1 solution should be correct" do
    assert Day13.solve_part1() == 631
  end

  test "part 2 solution should output the code as string" do
    expected_output = """
    XXXX.XXXX.X....XXXX...XX..XX..XXX..XXXX
    X....X....X....X.......X.X..X.X..X.X...
    XXX..XXX..X....XXX.....X.X....X..X.XXX.
    X....X....X....X.......X.X.XX.XXX..X...
    X....X....X....X....X..X.X..X.X.X..X...
    XXXX.X....XXXX.X.....XX...XXX.X..X.X...
    """

    assert capture_io(fn ->
             Day13.solve_part2()
           end) == expected_output
  end
end
