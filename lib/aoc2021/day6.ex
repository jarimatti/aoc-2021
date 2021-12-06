defmodule Aoc2021.Day6 do
  @moduledoc """
  See https://adventofcode.com/2021/day/6
  """

  defmodule Parser do
    @moduledoc false

    @spec read_input(Path.t()) :: [non_neg_integer()]
    def read_input(path) do
      path
      |> File.stream!()
      |> Stream.take(1)
      |> Stream.map(&parse_line/1)
      |> Enum.to_list()
      |> hd()
    end

    defp parse_line(line) do
      line
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end
  end

  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day6/input.txt") do
    Parser.read_input(path)
    0
  end
end
