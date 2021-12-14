defmodule Aoc2021.Day14 do
  @moduledoc """
  See https://adventofcode.com/2021/day/14
  """

  @type template() :: charlist()
  @type charmap() :: %{charlist() => charlist()}

  defmodule Reader do
    @moduledoc false

    @spec read_input(Path.t()) :: {Aoc2021.Day14.template(), Aoc2021.Day14.charmap()}
    def read_input(path) do
      [start, "" | rest] =
        path
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> Enum.to_list()

      start = String.to_charlist(start)
      map = Map.new(rest, &parse_mapping/1)

      {start, map}
    end

    defp parse_mapping(s) do
      [from, to] = String.split(s, " -> ")
      from = String.to_charlist(from)
      [to] = String.to_charlist(to)
      {from, to}
    end
  end

  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day14/input.txt") do
    {start, map} = Reader.read_input(path)

    solve_iteration(10, start, map)
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(path \\ "priv/day14/input.txt") do
    {start, map} = Reader.read_input(path)

    solve_iteration(40, start, map)
  end

  defp solve_iteration(n, s, map) do
    s
    |> Enum.chunk_every(2, 1)
    |> Enum.frequencies()
    |> Stream.iterate(&step_iteration(&1, map))
    |> Enum.at(n)
    |> Enum.reduce(%{}, fn
      {c, count}, acc ->
        Map.update(acc, hd(c), count, fn x -> x + count end)
    end)
    |> score()
  end

  defp step_iteration(freqs, map) do
    freqs
    |> Enum.flat_map(fn
      {[a, b] = s, count} ->
        c = Map.get(map, s)
        [{[a, c], count}, {[c, b], count}]

      c ->
        [c]
    end)
    |> Enum.reduce(%{}, fn
      {l, count}, acc ->
        Map.update(acc, l, count, fn x -> x + count end)
    end)
  end

  defp score(freqs) do
    {min, max} =
      freqs
      |> Map.values()
      |> Enum.min_max()

    max - min
  end
end
