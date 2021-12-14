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

  @spec solve(non_neg_integer(), template(), charmap()) :: non_neg_integer()
  def solve(n, start, map) do
    # This a straight-forward solution and it works for part 1, but for part 2 the length of the list explodes.
    # However we can process this depth-first, taking each pair and running them through all steps, then proceeding to next pair.
    # Given we're only interested in the counts, we can just track a map of the counts and don't need to keep the whole list in memory.
    #
    # Scratch that, the depth-first also grows exponentially.
    #
    # Had to look up other solutions and they were much better: instead of recursing, iterate over the pair counts.

    1..n
    |> Enum.reduce(start, fn _, acc -> step(acc, map) end)
    |> Enum.frequencies()
    |> score()
  end

  @spec step(template(), charmap()) :: template()
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

  def step_recursion(s, map, i) do
    s
    |> Enum.chunk_every(2, 1)
    |> Enum.reduce(%{}, fn
      [_a, _b] = s, acc ->
        step_recursion(s, map, i, acc)

      [c], acc ->
        add_count(acc, c)
    end)
    |> score()
  end

  defp score(freqs) do
    {min, max} =
      freqs
      |> Map.values()
      |> Enum.min_max()

    max - min
  end

  defp add_count(acc, c), do: Map.update(acc, c, 1, fn x -> x + 1 end)

  @spec step_recursion(template(), charmap(), non_neg_integer(), %{char() => non_neg_integer()}) ::
          %{
            char() => non_neg_integer()
          }
  def step_recursion([a, _b], _map, 0, counts) do
    add_count(counts, a)
  end

  def step_recursion([a, b] = s, map, i, counts) when i > 0 do
    c = Map.get(map, s)

    counts_1 = step_recursion([a, c], map, i - 1, counts)
    counts_2 = step_recursion([c, b], map, i - 1, counts_1)

    counts_2
  end

  def step_iteration(freqs, map) do
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

  def solve_iteration(n, s, map) do
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

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(path \\ "priv/day14/input.txt") do
    {start, map} = Reader.read_input(path)

    solve_iteration(40, start, map)
  end
end
