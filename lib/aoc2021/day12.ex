defmodule Aoc2021.Day12 do
  @moduledoc """
  See https://adventofcode.com/2021/day/12
  """

  defmodule Reader do
    @moduledoc false

    @spec read_input(Path.t()) :: :digraph.graph()
    def read_input(path) do
      path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.reject(&empty_line?/1)
      |> Stream.map(&parse_edge/1)
      |> Enum.reduce(:digraph.new(), &add_edge/2)
    end

    defp empty_line?(""), do: true
    defp empty_line?(_), do: false

    defp parse_edge(line) do
      [a, b] = String.split(line, "-")
      {a, b}
    end

    defp add_edge({"start", b}, g) do
      va = add_vertex(g, "start")
      vb = add_vertex(g, b)
      :digraph.add_edge(g, va, vb)
      g
    end

    defp add_edge({b, "start"}, g) do
      add_edge({"start", b}, g)
    end

    defp add_edge({"end", b}, g) do
      va = add_vertex(g, "end")
      vb = add_vertex(g, b)
      :digraph.add_edge(g, vb, va)
      g
    end

    defp add_edge({b, "end"}, g) do
      add_edge({"end", b}, g)
    end

    defp add_edge({a, b}, g) do
      va = add_vertex(g, a)
      vb = add_vertex(g, b)
      :digraph.add_edge(g, va, vb)
      :digraph.add_edge(g, vb, va)
      g
    end

    defp add_vertex(g, a) do
      :digraph.add_vertex(g, a, type(a))
    end

    defp type("start"), do: :start
    defp type("end"), do: :end

    defp type(a) do
      if String.upcase(a) == a do
        :big
      else
        :small
      end
    end
  end

  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day11/input.txt") do
    graph = Reader.read_input(path)

    :digraph.delete(graph)
    # stub
    0
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(path \\ "priv/day11/input.txt") do
    graph = Reader.read_input(path)

    :digraph.delete(graph)
    # stub
    0
  end
end
