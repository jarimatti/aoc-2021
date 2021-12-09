defmodule Aoc2021.Day8 do
  @moduledoc """
  See https://adventofcode.com/2021/day/8
  """

  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day8/input.txt") do
    path
    |> read_input()
    |> Stream.map(fn {_, v} -> v end)
    |> Stream.map(fn v -> Enum.count(v, &is_easy_digit/1) end)
    |> Enum.sum()
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(path \\ "priv/day8/input.txt") do
    path
    |> read_input()
    |> Stream.map(&determine_number/1)
    |> Enum.sum()
  end

  defp determine_number({a, b}) do
    map = mappings(a)

    b
    |> Enum.map(fn x -> Map.get(map, x) end)
    |> Integer.undigits()
  end

  defp mappings(list) do
    {easy, complex} = Enum.split_with(list, &is_easy_digit/1)

    easy_digits =
      Enum.reduce(easy, %{}, fn d, acc ->
        dd = map_easy_digit(d)
        Map.put(acc, dd, d)
      end)

    complex
    |> Enum.reduce(easy_digits, fn d, acc ->
      dd = map_hard_digit(d, acc)
      Map.put(acc, dd, d)
    end)
    |> swap_key_value()
  end

  defp swap_key_value(map) do
    map
    |> Map.to_list()
    |> Enum.map(fn {k, v} -> {v, k} end)
    |> Map.new()
  end

  defp map_easy_digit(d) do
    case MapSet.size(d) do
      2 -> 1
      3 -> 7
      4 -> 4
      7 -> 8
    end
  end

  defp map_hard_digit(d, map) do
    case MapSet.size(d) do
      5 ->
        map_2_3_5(d, map)

      6 ->
        map_0_6_9(d, map)
    end
  end

  defp map_2_3_5(d, map) do
    diff_to_1 = MapSet.size(MapSet.difference(d, Map.get(map, 1)))
    diff_to_4 = MapSet.size(MapSet.difference(d, Map.get(map, 4)))

    case {diff_to_1, diff_to_4} do
      {3, _} -> 3
      {_, 2} -> 5
      {_, 3} -> 2
    end
  end

  defp map_0_6_9(d, map) do
    diff_to_1 = MapSet.size(MapSet.difference(d, Map.get(map, 1)))
    diff_to_4 = MapSet.size(MapSet.difference(d, Map.get(map, 4)))

    case {diff_to_1, diff_to_4} do
      {4, 3} -> 0
      {5, 3} -> 6
      {4, 2} -> 9
    end
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

  def alphabet do
    MapSet.new([:a, :b, :c, :d, :e, :f, :g])
  end

  defp parse_line(line) do
    [a, b] =
      line
      |> String.split(" | ")
      |> Enum.map(&String.split/1)

    sa = Enum.map(a, &parse_segment_set/1)
    sb = Enum.map(b, &parse_segment_set/1)

    {sa, sb}
  end

  defp parse_segment_set(word) do
    word
    |> String.graphemes()
    |> Enum.map(&String.to_existing_atom/1)
    |> MapSet.new()
  end

  defp is_easy_digit(s) do
    MapSet.size(s) in [2, 3, 4, 7]
  end
end
