defmodule Aoc2021.Day5 do
  @moduledoc """
  See https://adventofcode.com/2021/day/5
  """

  alias Aoc2021.Day5.Line
  alias Aoc2021.Day5.Parser

  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day5/input.txt") do
    path
    |> File.stream!()
    |> Parser.parse()
    |> Enum.filter(fn l -> Line.orientation(l) in [:horizontal, :vertical] end)
    |> Enum.reduce(%{}, &add_points_to_chart/2)
    |> Enum.count(fn {_, v} -> v > 1 end)
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(path \\ "priv/day5/input.txt") do
    path
    |> File.stream!()
    |> Parser.parse()
    |> Enum.reduce(%{}, &add_points_to_chart/2)
    |> Enum.count(fn {_, v} -> v > 1 end)
  end

  defp add_points_to_chart(line, chart) do
    line
    |> Line.points()
    |> Enum.reduce(chart, &add_point_to_chart/2)
  end

  defp add_point_to_chart(point, chart) do
    Map.update(chart, point, 1, fn x -> x + 1 end)
  end
end
