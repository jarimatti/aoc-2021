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
  def solve_part2(path \\ "priv/day9/input.txt") do
    map = read_map(path)

    map
    |> low_points()
    |> Enum.map(fn lp -> basin(lp, map) end)

    |> Enum.map(&length/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp basin(p, map) do
    # A basin is all locations that eventually flow downward to a single low
    # point. Therefore, every low point has a basin, although some basins are
    # very small. Locations of height 9 do not count as being in any basin, and
    # all other locations will always be part of exactly one basin.

    basin(p, map, MapSet.new())
  end

  defp basin({_, :border}, _, _), do: []
  defp basin({_, 9}, _, _), do: []

  defp basin({{r, c}, _} = p, map, seen) do
    if MapSet.member?(seen, p) do
      []
    else
      [p1, p2, p3, p4] =
        [{r + 1, c}, {r - 1, c}, {r, c + 1}, {r, c - 1}]
        |> Enum.map(fn pos -> {pos, height(map, pos)} end)

      seen = MapSet.put(seen, p)
      n1 = basin(p1, map, seen)
      seen = mark_seen(n1, seen)
      n2 = basin(p2, map, seen)
      seen = mark_seen(n2, seen)
      n3 = basin(p3, map, seen)
      seen = mark_seen(n3, seen)
      n4 = basin(p4, map, seen)

      [p] ++ n1 ++ n2 ++ n3 ++ n4
    end
  end

  defp mark_seen(points, seen) do
    Enum.reduce(points, seen, fn x, acc -> MapSet.put(acc, x) end)
  end

  defp height(map, p), do: Map.get(map, p, :border)

  defp low_points(map) do
    Enum.filter(map, fn p -> low_point?(p, map) end)
  end

  defp low_point?({pos, height}, map) do
    pos
    |> neighbour_heights(map)
    |> Enum.all?(fn nh -> nh > height end)
  end

  defp border?(:border), do: true
  defp border?(_), do: false

  defp neighbour_heights({row, col}, map) do
    [{row - 1, col}, {row + 1, col}, {row, col - 1}, {row, col + 1}]
    |> Enum.map(fn pos -> height(map, pos) end)
    |> Enum.reject(&border?/1)
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
