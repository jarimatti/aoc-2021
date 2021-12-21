defmodule Aoc2021.Day16.EvaluatorTest do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day16.Evaluator

  alias Aoc2021.Day16.Parser
  alias Aoc2021.Day16.Evaluator

  test "sum" do
    assert evaluate("C200B40A82") == 3
  end

  test "prod" do
    assert evaluate("04005AC33890") == 54
  end

  test "min" do
    assert evaluate("880086C3E88112") == 7
  end

  test "max" do
    assert evaluate("CE00C43D881120") == 9
  end

  test "lt" do
    assert evaluate("D8005AC2A8F0") == 1
  end

  test "gt" do
    assert evaluate("F600BC2D8F") == 0
  end

  test "eq" do
    assert evaluate("9C005AC2F8F0") == 0
  end

  test "1 + 3 = 2 * 2" do
    assert evaluate("9C0141080250320F1802104A08") == 1
  end

  defp evaluate(string) do
    string
    |> parse()
    |> Evaluator.evaluate()
  end

  defp parse(string) do
    {p, _} =
      string
      |> Base.decode16!()
      |> Parser.parse_packet()

    p
  end
end
