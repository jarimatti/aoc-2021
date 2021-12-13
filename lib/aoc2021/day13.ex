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
    IO.inspect(dots)
    IO.inspect(instructions)
    0
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(_path \\ "priv/day13/input.txt") do
    # stub
    0
  end
end
