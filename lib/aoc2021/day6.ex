defmodule Aoc2021.Day6 do
  @moduledoc """
  See https://adventofcode.com/2021/day/6
  """

  defmodule Parser do
    @moduledoc false

    @spec read_input(Path.t()) :: [non_neg_integer()]
    def read_input(path) do
      path
      |> File.stream!()
      |> Stream.take(1)
      |> Stream.map(&parse_line/1)
      |> Enum.to_list()
      |> hd()
    end

    defp parse_line(line) do
      line
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Exponential growth.

    For each initial fish we know the amount of delays until it reproduces, so
    can count them off. So this is variable initial delay.

    For each born fish we know that there's 2 extra day delay until it
    reproduces with cycle of 6.

    We can assume that the initial delay for the initial fish was also 8 and
    sync the formula to that.

    I was thinking about exponential growth formula, but couldn't make it work.
    Reached out to forums and the solution is obvious: make a bucket per
    maturity day and update the fish counts in the buckets. Simple, way simpler
    what I was thiking about.
    """

    @spec bucket_solve([non_neg_integer()], non_neg_integer()) :: non_neg_integer()
    def bucket_solve(inputs, t) do
      initial = Enum.frequencies(inputs)
      simulate(initial, t, 0)
    end

    defp simulate(fish, max_t, max_t) do
      fish
      |> Map.values()
      |> Enum.sum()
    end

    defp simulate(fish, max_t, t) do
      fish
      |> Enum.reduce(%{}, fn
        {0, count}, acc ->
          acc
          |> add_fish(6, count)
          |> add_fish(8, count)

        {t, count}, acc ->
          add_fish(acc, t - 1, count)
      end)
      |> simulate(max_t, t + 1)
    end

    defp add_fish(fish, t, count) do
      Map.update(fish, t, count, fn x -> x + count end)
    end
  end

  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day6/input.txt") do
    path
    |> Parser.read_input()
    |> Part1.bucket_solve(80)
  end

  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(path \\ "priv/day6/input.txt") do
    path
    |> Parser.read_input()
    |> Part1.bucket_solve(256)
  end
end
