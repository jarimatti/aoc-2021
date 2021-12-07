defmodule Aoc2021.Day7 do
  @moduledoc """
  See https://adventofcode.com/2021/day/7
  """

  @spec read_input(Path.t()) :: [non_neg_integer()]
  def read_input(path) do
    path
    |> File.stream!()
    |> Stream.take(1)
    |> Stream.map(&String.trim/1)
    |> Stream.flat_map(&String.split(&1, ","))
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
  end

  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day7/input.txt") do
    # Minimising the distance function d(k) = abs(x-k)
    # This is same as minimising the squares of distances d(k) = (x - k)^2
    # where x = vector of initial values, k = the target value (some constant).

    input = read_input(path)
    k = median(input)
    distance(input, k)
  end

  defp mean(list) do
    # Is not the mean
    Enum.sum(list) / length(list)
  end

  defp median(list) do
    # Median solves test data, but not full problem data
    sorted = Enum.sort(list)
    l = length(sorted)
    middle = div(l, 2)
    Enum.at(sorted, middle)
  end

  defp brute_force_part1(list) do
    a = Enum.min(list)
    b = Enum.max(list)

    a..b
    |> Enum.map(fn x -> {distance(list, x), x} end)
    |> Enum.min()
  end

  def distance(list, k) do
    list
    |> Enum.map(fn x -> abs(x - k) end)
    |> Enum.sum()
  end
end
