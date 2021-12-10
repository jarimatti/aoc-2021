defmodule Aoc2021.Day9 do
  @moduledoc """
  See https://adventofcode.com/2021/day/9
  """

  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day9/input.txt") do
    path
    |> read_map()
    |> IO.inspect()

    0
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(_path \\ "priv/day9/input.txt") do
    # stub
    0
  end

  def read_map(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Enum.reduce({0, %{}}, fn line, {row, acc} ->
      {
        row + 1,
        read_map_row(line, row, acc)
      }
    end)
  end

  def read_map_row(line, row, acc) do
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
