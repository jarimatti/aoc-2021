defmodule Aoc2021.Day13 do
  @moduledoc """
  See https://adventofcode.com/2021/day/13
  """

  @type instruction() :: {:fold_x, non_neg_integer()} | {:fold_y, non_neg_integer()}

  defmodule Reader do
    @moduledoc false

    @spec read_input(Path.t()) :: {MapSet.t(), [Aoc2021.Day13.instruction()]}
    def read_input(path) do
      {points, instructions} =
        path
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> Enum.split_while(&non_empty?/1)

      # Drop empty line
      instructions = tl(instructions)

      {parse_points(points), parse_instructions(instructions)}
    end

    defp non_empty?(""), do: false
    defp non_empty?(_), do: true

    defp parse_points(lines) do
      lines
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(fn line -> Enum.map(line, &String.to_integer/1) end)
      |> Enum.reduce(MapSet.new(), fn [x, y], acc -> MapSet.put(acc, {x, y}) end)
    end

    defp parse_instructions(lines) do
      lines
      |> Enum.map(&String.replace(&1, "fold along ", ""))
      |> Enum.map(&String.split(&1, "="))
      |> Enum.map(&parse_instruction/1)
    end

    defp parse_instruction(["x", x]), do: {:fold_x, String.to_integer(x)}
    defp parse_instruction(["y", y]), do: {:fold_y, String.to_integer(y)}
  end

  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day13/input.txt") do
    {dots, instructions} = Reader.read_input(path)

    instructions
    |> hd()
    |> List.wrap()
    |> apply_folds(dots)
    |> MapSet.size()
  end

  @spec solve_part2() :: :ok
  @spec solve_part2(Path.t()) :: :ok
  def solve_part2(path \\ "priv/day13/input.txt") do
    {dots, instructions} = Reader.read_input(path)

    dots =
      instructions
      |> apply_folds(dots)

    output = format_dots(dots)
    IO.puts(output)
  end

  defp apply_folds(instructions, dots) do
    Enum.reduce(instructions, dots, &apply_fold/2)
  end

  defp apply_fold({:fold_x, x}, dots) do
    reject = fn {xx, _} -> x == xx end
    split = fn {xx, _} -> xx < x end
    map = fn {xx, y} -> {x - (xx - x), y} end

    apply_fold_with(dots, reject, split, map)
  end

  defp apply_fold({:fold_y, y}, dots) do
    reject = fn {_, yy} -> y == yy end
    split = fn {_, yy} -> yy < y end
    map = fn {x, yy} -> {x, y - (yy - y)} end

    apply_fold_with(dots, reject, split, map)
  end

  defp apply_fold_with(dots, reject, split, map) do
    {under, over} =
      dots
      |> Enum.reject(&reject.(&1))
      |> Enum.split_with(&split.(&1))

    under = MapSet.new(under)
    over = MapSet.new(over, &map.(&1))

    MapSet.union(under, over)
  end

  defp format_dots(dots) do
    max_x =
      dots
      |> Enum.map(fn {x, _} -> x end)
      |> Enum.sort(:desc)
      |> hd()

    max_y =
      dots
      |> Enum.map(fn {_, y} -> y end)
      |> Enum.sort(:desc)
      |> hd()

    lines =
      for y <- 0..max_y do
        list =
          for x <- 0..max_x do
            if MapSet.member?(dots, {x, y}) do
              "X"
            else
              "."
            end
          end

        Enum.join(list)
      end

    Enum.join(lines, "\n")
  end
end
