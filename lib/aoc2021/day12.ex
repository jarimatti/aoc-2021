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
  def solve_part1(path \\ "priv/day12/input.txt") do
    graph = Reader.read_input(path)

    result =
      graph
      |> paths()
      |> length()

    :digraph.delete(graph)

    result
  end

  defp paths(g) do
    paths(g, "start", MapSet.new(), ["start"], [])
  end

  defp paths(g, vertex, visited_small, path, paths) do
    new_visited = add_if_small(visited_small, vertex, g, &mark_visit/2)

    g
    |> :digraph.out_neighbours(vertex)
    |> Enum.reject(fn v -> MapSet.member?(new_visited, v) end)
    |> Enum.flat_map(fn
      "end" ->
        p = Enum.reverse(["end" | path])
        [p | paths]

      v ->
        paths(g, v, new_visited, [v | path], paths)
    end)
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(path \\ "priv/day12/input.txt") do
    graph = Reader.read_input(path)

    result =
      graph
      |> paths_one_extra_visit()
      |> length()

    :digraph.delete(graph)

    result
  end

  defp paths_one_extra_visit(g) do
    paths_one_extra_visit(g, "start", %{}, ["start"], [])
  end

  defp paths_one_extra_visit(g, vertex, visited_small, path, paths) do
    # Idea 1: map where count is the visited amount. (current attempt)
    # Idea 2: keep using MapSet, add boolean flag if some small has been visited twice and branch based on that

    g
    |> :digraph.out_neighbours(vertex)
    |> Enum.flat_map(fn
      "end" ->
        p = Enum.reverse(["end" | path])
        [p | paths]

      v ->
        # recurse if conditions are met:
        # - one small cave can be visited twice
        # - other small caves can be visited only once

        new_visited = add_if_small(visited_small, vertex, g, &mark_visit_one_extra/2)

        case recurse_conditions?(new_visited, v) do
          true -> paths_one_extra_visit(g, v, new_visited, [v | path], paths)
          false -> []
        end
    end)
  end

  defp mark_visit(visited_small, vertex) do
    MapSet.put(visited_small, vertex)
  end

  defp mark_visit_one_extra(visited_small, vertex) do
    Map.update(visited_small, vertex, 1, fn x -> x + 1 end)
  end

  defp add_if_small(visited_small, vertex, g, adder) do
    case :digraph.vertex(g, vertex) do
      {_, t} when t in [:small, :start] ->
        adder.(visited_small, vertex)

      {_, :big} ->
        visited_small
    end
  end

  defp recurse_conditions?(visited, vertex) do
    any_seen_twice =
      visited
      |> Map.values()
      |> Enum.member?(2)

    seen_count = Map.get(visited, vertex, 0)

    case {any_seen_twice, seen_count} do
      {false, _} -> true
      {true, 0} -> true
      {true, _} -> false
    end
  end
end
