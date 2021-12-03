defmodule Aoc2021.Day3 do
  @moduledoc """
  See https://adventofcode.com/2021/day/3
  """

  @spec solve_part1 :: integer
  def solve_part1() do
    input = read_input() |> count_bits_by_position()
    epsilon(input) * gamma(input)
  end

  @spec read_input() :: Enum.t()
  def read_input() do
    read_input("priv/day3/input.txt")
  end

  @spec read_input(Path.t()) :: Enum.t()
  def read_input(path) do
    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> Stream.reject(fn line -> line == "" end)
  end

  defp gamma(list) do
    digits_to_number(list, &gamma_digit/1)
  end

  defp epsilon(list) do
    digits_to_number(list, &epsilon_digit/1)
  end

  defp digits_to_number(list, f) do
    list
    |> Enum.map(fn {_, x} -> x end)
    |> Enum.map(f)
    |> Enum.reverse()
    |> Integer.undigits(2)
  end

  defp gamma_digit({a, b}) when a > b, do: 0
  defp gamma_digit(_), do: 1

  defp epsilon_digit({a, b}) when a > b, do: 1
  defp epsilon_digit(_), do: 0

  @spec count_bits_by_position(Enum.t()) :: [{integer(), {non_neg_integer(), non_neg_integer()}}]
  def count_bits_by_position(stream) do
    stream
    |> Enum.reduce(%{}, &count_bits/2)
    |> Enum.sort()
  end

  defp count_bits(line, acc) do
    count_bits(line, acc, String.length(line) - 1)
  end

  defp count_bits("", acc, _) do
    acc
  end

  defp count_bits("1" <> rest, acc, n) do
    count_bits(rest, Map.update(acc, n, {0, 1}, fn {a, b} -> {a, b + 1} end), n - 1)
  end

  defp count_bits("0" <> rest, acc, n) do
    count_bits(rest, Map.update(acc, n, {1, 0}, fn {a, b} -> {a + 1, b} end), n - 1)
  end
end
