defmodule Aoc2021.Day11 do
  @moduledoc """
  See https://adventofcode.com/2021/day/11
  """

  defmodule Reader do
    @moduledoc false

    def read_input(path) do
      path
      |> File.stream!()
      |> parse_map()
    end

    def parse_map(stream) do
      {map, _} =
        stream
        |> Stream.map(&String.trim/1)
        |> Stream.reject(&empty_line?/1)
        |> Stream.map(&String.graphemes/1)
        |> Stream.map(&parse_numbers/1)
        |> Enum.reduce({%{}, 0}, &parse_line/2)

      map
    end

    defp empty_line?(""), do: true
    defp empty_line?(_), do: false

    defp parse_numbers(line) do
      Enum.map(line, &String.to_integer/1)
    end

    defp parse_line(line, {map, row}) do
      {new_map, _} =
        Enum.reduce(line, {map, 0}, fn x, {map, col} ->
          {Map.put(map, {row, col}, x), col + 1}
        end)

      {new_map, row + 1}
    end
  end

  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day11/input.txt") do
    map = Reader.read_input(path)

    {_, count} =
      Enum.reduce(1..100, {map, 0}, fn _, {map, flash_count} ->
        new_map = step(map)

        {reset_flashed(new_map), flash_count + count_flashes(new_map)}
      end)

    count
  end

  defp count_flashes(map) do
    Enum.count(map, fn {_, v} -> v > 9 end)
  end

  defp reset_flashed(map) do
    map
    |> Enum.map(fn
      {k, v} when v > 9 -> {k, 0}
      {k, v} -> {k, v}
    end)
    |> Map.new()
  end

  defp step(map) do
    {new_map, _} =
      map
      |> Map.keys()
      |> Enum.reduce({map, MapSet.new()}, &increase_energy/2)

    new_map
  end

  defp increase_energy(pos, {map, seen}) do
    new_seen = MapSet.put(seen, pos)

    case Map.get(map, pos, :outside) do
      :outside ->
        {map, seen}

      x when x > 9 ->
        # already flashed, no change
        {map, new_seen}

      9 = x ->
        # flash! recurse to neighbours
        new_map = Map.put(map, pos, x + 1)

        pos
        |> neighbours()
        |> Enum.reduce({new_map, new_seen}, &increase_energy/2)

      x when x < 9 ->
        {Map.put(map, pos, x + 1), new_seen}
    end
  end

  defp neighbours({row, col}) do
    for dr <- -1..1, dc <- -1..1, {dr, dc} != {0, 0} do
      {row + dr, col + dc}
    end
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(path \\ "priv/day11/input.txt") do
    map = Reader.read_input(path)

    first_all_flash_step(map)
  end

  defp first_all_flash_step(map) do
    first_all_flash_step(map, 0, all_flash?(map))
  end

  defp first_all_flash_step(_, s, true), do: s

  defp first_all_flash_step(map, s, _) do
    new_map = step(map)

    new_map
    |> reset_flashed()
    |> first_all_flash_step(s + 1, all_flash?(new_map))
  end

  def all_flash?(map) do
    count_flashes(map) == map_size(map)
  end
end
