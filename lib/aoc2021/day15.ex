defmodule Aoc2021.Day15 do
  @moduledoc """
  See https://adventofcode.com/2021/day/15
  """

  @type pos() :: {non_neg_integer(), non_neg_integer()}
  @type riskmap() :: %{pos() => non_neg_integer()}

  defmodule Reader do
    @moduledoc false

    @spec read_map(Path.t()) :: {Aoc2021.Day15.riskmap(), Aoc2021.Day15.pos()}
    def read_map(path) do
      path
      |> File.stream!()
      |> read_map_from_stream()
    end

    @spec read_map_from_stream(Enum.t()) :: {Aoc2021.Day15.riskmap(), Aoc2021.Day15.pos()}
    def read_map_from_stream(stream) do
      {map, _} =
        stream
        |> Stream.map(&String.trim/1)
        |> Stream.map(&String.codepoints/1)
        |> Enum.reduce({%{}, 0}, &parse_line/2)

      {{max_x, _}, _} = Enum.max_by(map, fn {{x, _}, _} -> x end)
      {{_, max_y}, _} = Enum.max_by(map, fn {{_, y}, _} -> y end)

      {map, {max_x, max_y}}
    end

    defp parse_line(line, {map, y}) do
      {map, _} =
        Enum.reduce(line, {map, 0}, fn c, {map, x} ->
          v = String.to_integer(c)
          {Map.put(map, {x, y}, v), x + 1}
        end)

      {map, y + 1}
    end
  end

  defmodule AStar do
    @moduledoc """
    A* path search.

    See https://en.wikipedia.org/wiki/A*_search_algorithm
    """

    @infinity 1_000_000

    @spec a_star(
            Aoc2021.Day15.riskmap(),
            Aoc2021.Day15.pos(),
            Aoc2021.Day15.pos(),
            (Aoc2021.Day15.pos() -> non_neg_integer()),
            (Aoc2021.Day15.pos() -> [Aoc2021.Day15.pos()])
          ) ::
            {:ok, [Aoc2021.Day15.pos()]} | {:error, :path_not_found}
    def a_star(map, start, goal, h, neighbours) do
      open_set = Heap.new(fn {_, a}, {_, b} -> a < b end)
      open_set = Heap.push(open_set, {start, 0})
      came_from = %{}

      # Default value infinity
      g_score = Map.new([{start, 0}])
      f_score = Map.new([{start, h.(start)}])

      recurse(map, goal, h, neighbours, open_set, came_from, g_score, f_score)
    end

    defp recurse(map, goal, h, neighbours, open_set, came_from, g_score, f_score) do
      {{current, _}, open_set} = Heap.split(open_set)

      case current == goal do
        true ->
          {:ok, reconstruct_path(came_from, current)}

        false ->
          ns = neighbours.(current)

          {came_from, g_score, f_score, open_set} =
            Enum.reduce(
              ns,
              {came_from, g_score, f_score, open_set},
              &step_neighbour(&1, &2, current, map, h)
            )

          recurse(map, goal, h, neighbours, open_set, came_from, g_score, f_score)
      end
    end

    defp step_neighbour(neighbour, {came_from, g_score, f_score, open_set}, current, map, h) do
      tentative_g_score = get_score(g_score, current) + d(map, current, neighbour)

      if tentative_g_score < get_score(g_score, neighbour) do
        came_from = Map.put(came_from, neighbour, current)
        g_score = Map.put(g_score, neighbour, tentative_g_score)
        f_score = Map.put(f_score, neighbour, tentative_g_score + h.(neighbour))
        open_set = Heap.push(open_set, {neighbour, tentative_g_score})

        {came_from, g_score, f_score, open_set}
      else
        {came_from, g_score, f_score, open_set}
      end
    end

    defp d(map, _current, neighbour) do
      Map.get(map, neighbour)
    end

    defp get_score(scores, pos) do
      Map.get(scores, pos, @infinity)
    end

    defp reconstruct_path(came_from, current) do
      reconstruct_path(came_from, Map.get(came_from, current), [current])
    end

    defp reconstruct_path(_, nil, path), do: path

    defp reconstruct_path(came_from, current, path) do
      reconstruct_path(came_from, Map.get(came_from, current), [current | path])
    end
  end

  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day15/input.txt") do
    {map, {max_x, max_y} = goal} = Reader.read_map(path)
    start = {0, 0}
    h = make_h(goal)
    n = make_neighbours(max_x, max_y)

    {:ok, path} = AStar.a_star(map, start, goal, h, n)

    path
    |> tl()
    |> Enum.map(fn p -> Map.get(map, p) end)
    |> Enum.sum()
  end

  defp make_neighbours(max_x, max_y) do
    fn {x, y} ->
      [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
      |> Enum.filter(fn {x, y} -> x >= 0 and y >= 0 and x <= max_x and y <= max_y end)
    end
  end

  defp make_h({goal_x, goal_y}) do
    fn {x, y} ->
      abs(goal_x - x) + abs(goal_y - y)
    end
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(path \\ "priv/day15/input.txt") do
    {map, {max_x, max_y} = goal} =
      path
      |> Reader.read_map()
      |> build_map()

    start = {0, 0}
    h = make_h(goal)
    n = make_neighbours(max_x, max_y)

    {:ok, path} = AStar.a_star(map, start, goal, h, n)

    path
    |> tl()
    |> Enum.map(fn p -> Map.get(map, p) end)
    |> Enum.sum()
  end

  defp increase_cell_value(x) when x > 9, do: rem(x, 10) + 1
  defp increase_cell_value(x), do: x

  defp build_map({initial, {max_x, max_y}}) do
    row =
      for n <- 0..4 do
        Map.new(initial, fn {{x, y}, v} ->
          {{x + n * (max_x + 1), y}, increase_cell_value(v + n)}
        end)
      end
      |> Enum.reduce(%{}, &Map.merge/2)

    map =
      for n <- 0..4 do
        Map.new(row, fn {{x, y}, v} ->
          {{x, y + n * (max_y + 1)}, increase_cell_value(v + n)}
        end)
      end
      |> Enum.reduce(%{}, &Map.merge/2)

    {map, {(max_x + 1) * 5 - 1, (max_y + 1) * 5 - 1}}
  end
end
