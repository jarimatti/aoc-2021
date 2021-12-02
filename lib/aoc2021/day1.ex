defmodule Aoc2021.Day1 do
  @moduledoc """
  See https://adventofcode.com/2021/day/1
  """

  @spec solve_part1 :: non_neg_integer
  def solve_part1() do
    read_input()
    |> count_increments()
  end

  @spec solve_part2 :: non_neg_integer
  def solve_part2() do
    read_input()
    |> sum_windows()
    |> count_increments()
  end

  @doc """
  Sum all full 3 element windows in the stream.
  """
  @spec sum_windows(Enum.t()) :: Enum.t()
  def sum_windows(input) do
    input
    |> Stream.chunk_every(3, 1, :discard)
    |> Stream.map(&Enum.sum/1)
  end

  @doc """
  Count how many measurements in input are greater than previous value.
  """
  @spec count_increments(Enum.t()) :: non_neg_integer()
  def count_increments(input) do
    input
    |> Stream.scan(&is_next_greater/2)
    |> Stream.map(&take_delta/1)
    |> Enum.sum()
  end

  defp take_delta({_, d}), do: d
  defp take_delta(_), do: 0

  defp is_next_greater(next, {prev, _}) when next > prev do
    {next, 1}
  end

  defp is_next_greater(next, prev) when is_integer(prev) and next > prev do
    {next, 1}
  end

  defp is_next_greater(next, _) do
    {next, 0}
  end

  @doc """
  Produce a stream of integers from the input file.
  """
  @spec read_input :: Enum.t()
  def read_input() do
    File.stream!("priv/day1/input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.reject(fn line -> line == "" end)
    |> Stream.map(fn line ->
      {i, _} = Integer.parse(line)
      i
    end)
  end
end
