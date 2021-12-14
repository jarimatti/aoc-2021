defmodule Aoc2021.Day14 do
  @moduledoc """
  See https://adventofcode.com/2021/day/14
  """

  defmodule Reader do
    @moduledoc false

    @spec read_input(Path.t()) :: {charlist(), %{charlist() => charlist()}}
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

    {{least, _}, {most, _}} =
      Enum.reduce(1..10, start, fn _, acc -> step(acc, map) end)
      |> Enum.frequencies()
      |> Enum.map(fn {a, b} -> {b, a} end)
      |> Enum.sort()
      |> Enum.min_max()

    most - least
  end

  @spec step(charlist(), %{charlist() => charlist()}) :: charlist()
  def step(s, map) do
    s
    |> Enum.chunk_every(2, 1)
    |> Enum.flat_map(fn
      [a, _b] = k ->
        c = Map.get(map, k)
        [a, c]

      [c] ->
        [c]
    end)
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(_path \\ "priv/day14/input.txt") do
    # stub
    0
  end
end
