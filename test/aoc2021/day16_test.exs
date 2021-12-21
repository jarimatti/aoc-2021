defmodule Aoc2021.Day16Test do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day16

  alias Aoc2021.Day16

  test "test packets produce correct sums" do
    assert Day16.parse_and_sum("8A004A801A8002F478") == 16
    assert Day16.parse_and_sum("620080001611562C8802118E34") == 12
    assert Day16.parse_and_sum("C0015000016115A2E0802F182340") == 23
    assert Day16.parse_and_sum("A0016C880162017C3686B18A3D4780") == 31
  end

  test "part 1 solution should be correct" do
    assert Day16.solve_part1() == 936
  end

  @tag :pending
  test "part 2 solution should be correct with test data" do
    assert Day16.solve_part2("priv/Day16/test-input.txt") == -1
  end

  @tag :pending
  test "part 2 solution should be correct" do
    assert Day16.solve_part2() == -1
  end
end
