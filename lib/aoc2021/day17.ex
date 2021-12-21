defmodule Aoc2021.Day17 do
  @moduledoc """
  See https://adventofcode.com/2021/day/17
  """

  @doc """
  Produce the highest y-position that the probe can reach while still hitting target area.
  """
  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day17/input.txt") do
    {_, yrange} = read_input(path)
    max_y(yrange)
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(path \\ "priv/day17/input.txt") do
    {_xrange, _yrange} = read_input(path)
    # We can count distinct v_y that hit the y range and v_x that hit the x range.
    # The velocities are a cartesian product of the pairs (v_x, v_y) and so we can just multiply their sizes together.
    0
  end

  @spec read_input(Path.t()) :: {Range.t(), Range.t()}
  def read_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> parse_input()
  end

  defp parse_input("target area: " <> values) do
    [xs, ys] = String.split(values, ", ")
    {parse_range(xs), parse_range(ys)}
  end

  defp parse_range(s) do
    [_, r] = String.split(s, "=")

    [a, b] =
      r
      |> String.split("..")
      |> Enum.map(&String.to_integer/1)

    Range.new(a, b)
  end

  @doc """
  Produce the maximum height given the starting y-axis velocity.
  """
  @spec max_height(integer()) :: non_neg_integer()
  def max_height(vy0) when vy0 >= 0, do: Enum.sum(0..vy0)
  def max_height(_), do: 0

  @doc """
  Produce maximum initial velocity that still causes a point to be in the y range
  """
  @spec max_y(Range.t()) :: non_neg_integer()
  def max_y(target) do
    # This is a brute-force solution, just iterating down from some high maximum y velocity.
    # Not elegant, but gets the job done. There is a formula for computing this, I'm sure.
    10000
    |> Stream.iterate(fn vy0 -> vy0 - 1 end)
    |> Stream.take_while(fn vy0 -> vy0 >= 0 end)
    |> Stream.map(&max_height/1)
    |> Stream.filter(fn y_max -> hits_box(y_max, target, 0) end)
    |> Stream.take(1)
    |> Enum.to_list()
    |> hd()
  end

  @doc """
  Produce true if the probe descending from y_max has a point in the box at any time.
  """
  @spec hits_box(non_neg_integer(), Range.t(), integer()) :: boolean()
  def hits_box(y, ymin..ymax, _v) when y in ymin..ymax do
    true
  end
  def hits_box(y, ymin.._ymax, _v) when y < ymin do
    false
  end
  def hits_box(y, range, v) do
    hits_box(y + v, range, v - 1)
  end
end
