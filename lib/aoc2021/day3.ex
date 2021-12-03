defmodule Aoc2021.Day3 do
  @moduledoc """
  See https://adventofcode.com/2021/day/3
  """

  defmodule Part1 do
    @spec gamma([{any, {integer, integer}}]) :: integer
    def gamma(list) do
      digits_to_number(list, &gamma_digit/1)
    end

    @spec epsilon([{any, {integer, integer}}]) :: integer
    def epsilon(list) do
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
  end

  @spec solve_part1 :: integer
  def solve_part1() do
    input = read_input() |> count_bits_by_position()
    Part1.epsilon(input) * Part1.gamma(input)
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

  @spec count_bits_by_position(Enum.t()) :: [{integer(), {non_neg_integer(), non_neg_integer()}}]
  def count_bits_by_position(stream) do
    stream
    |> Enum.reduce(%{}, &count_bits/2)
    |> Enum.sort()
  end

  defp count_bits(line, acc) do
    {map, _} =
      line
      |> String.graphemes()
      |> Enum.reduce({acc, String.length(line) - 1}, fn d, {acc, n} ->
        {update_digit(d, acc, n), n - 1}
      end)

    map
  end

  defp update_digit("1", acc, n) do
    Map.update(acc, n, {0, 1}, fn {a, b} -> {a, b + 1} end)
  end

  defp update_digit("0", acc, n) do
    Map.update(acc, n, {1, 0}, fn {a, b} -> {a + 1, b} end)
  end
end
