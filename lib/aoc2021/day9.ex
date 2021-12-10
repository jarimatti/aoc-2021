defmodule Aoc2021.Day9 do
  @moduledoc """
  See https://adventofcode.com/2021/day/9
  """

  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day9/input.txt") do
    path
    |> read_map()
    |> low_points()
    |> risk_levels()
    |> Enum.sum()
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(_path \\ "priv/day9/input.txt") do
    # stub
    0
  end

  defp low_points(map) do
    Enum.filter(map, fn p -> low_point?(p, map) end)
  end

  defp low_point?({pos, height}, map) do
    pos
    |> neighbour_heights(map)
    |> Enum.all?(fn nh -> nh > height end)
  end

  defp neighbour_heights({row, col}, map) do
    [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}]
    |> Enum.map(fn pos -> Map.get(map, pos, :border) end)
    |> Enum.reject(fn x -> x == :border end)
  end

  defp risk_levels(map) do
    Enum.map(map, fn {_, height} -> height + 1 end)
  end

  defp read_map(path) do
    {_, map} =
      path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Enum.reduce({0, %{}}, fn line, {row, acc} ->
        {
          row + 1,
          read_map_row(line, row, acc)
        }
      end)

    map
  end

  defp read_map_row(line, row, acc) do
    {_, map} =
      line
      |> String.graphemes()
      |> Enum.reduce({0, acc}, fn char, {col, acc} ->
        {
          col + 1,
          Map.put(acc, {row, col}, String.to_integer(char))
        }
      end)

    map
  end
end
