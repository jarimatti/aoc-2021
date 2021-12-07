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
    total_fuel_used(input, k, &crab_fuel_used1/2)
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(path \\ "priv/day7/input.txt") do
    input = read_input(path)
    search_minimum_fuel_used(input, &crab_fuel_used2/2)
  end


  # Quick way to solve part 1, no need to search.
  defp median(list) do
    sorted = Enum.sort(list)
    l = length(sorted)
    middle = div(l, 2)
    Enum.at(sorted, middle)
  end

  defp search_minimum_fuel_used(list, f) do
    a = Enum.min(list)
    b = Enum.max(list)

    a..b
    |> Enum.map(&total_fuel_used(list, &1, f))
    |> Enum.min()
  end

  def total_fuel_used(list, k, f) do
    list
    |> Enum.map(fn x -> f.(x, k) end)
    |> Enum.sum()
  end

  def crab_fuel_used1(x, k) do
    abs(x - k)
  end

  def crab_fuel_used2(x, k) do
    delta = abs(x - k)
    Enum.sum(0..delta)
  end
end
