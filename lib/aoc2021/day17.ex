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
    {xrange, yrange} = read_input(path)

    v0y_max = max_v0y(yrange)
    v0y_min = min_v0y(yrange)
    v0x_max = max_v0x(xrange)
    v0x_min = min_v0x(xrange, v0x_max)

    v0x = v0x_min..v0x_max
    v0y = v0y_min..v0y_max

    # Now we have the candidate range for initial velocities. Next up: filter
    # and count only those that land in the box. Contrary to initial thoughts
    # not all combinations work, these just give the extreme points.
    v0 = for x <- v0x, y <- v0y, do: {x, y}
    # TODO: Filter this.
    IO.inspect(v0)

    length(v0)
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

  defp max_v0y(target) do
    # This is a brute-force solution, just iterating down from some high maximum y velocity.
    # Not elegant, but gets the job done. There is a formula for computing this, I'm sure.
    10000
    |> Stream.iterate(fn vy0 -> vy0 - 1 end)
    |> Stream.take_while(fn vy0 -> vy0 >= 0 end)
    |> Stream.filter(fn vy0 -> hits_box(max_height(vy0), target, 0) end)
    |> Stream.take(1)
    |> Enum.to_list()
    |> hd()
  end

  defp min_v0y(target) do
    # This is simple: minimum velocity shoots down and _barely_ hits the lowest point of target.
    # Thus it is the lowest point of the target range.
    #
    # ASSUME: Target is below.
    Enum.min(target)
  end

  defp max_v0x(target) do
    # This is similar to min_v0y/1 above, only this time shoot towards target with maximum velocity that _barely_ hits the target.
    # Any faster than this and the first point will already overshoot.
    #
    # ASSUME: target is to the right.
    Enum.max(target)
  end

  defp min_v0x(target, v0x_max) do
    0
    |> Stream.iterate(fn v0x -> v0x + 1 end)
    |> Stream.take_while(fn v0x -> v0x <= v0x_max end)
    |> Stream.filter(fn v0x -> hits_box(max_height(v0x), target, 0) end)
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
