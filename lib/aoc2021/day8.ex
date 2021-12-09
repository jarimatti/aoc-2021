defmodule Aoc2021.Day8 do
  @moduledoc """
  See https://adventofcode.com/2021/day/8
  """

  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day8/input.txt") do
    path
    |> read_input()
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.map(fn v -> Enum.count(v, &is_easy_digit/1) end)
    |> Enum.sum()
  end

  defp read_input(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&empty_line?/1)
    |> Stream.map(&parse_line/1)
  end

  defp empty_line?(""), do: true
  defp empty_line?(_), do: false

  defp parse_line(line) do
    [a, b] =
      line
      |> String.split(" | ")
      |> Enum.map(&String.split/1)

    {a, b}
  end

  defp is_easy_digit(s) do
    String.length(s) in [2, 3, 4, 7]
  end
end
