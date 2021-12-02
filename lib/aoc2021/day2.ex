defmodule Aoc2021.Day2 do
  @moduledoc """
  See https://adventofcode.com/2021/day/2
  """

  alias Aoc2021.Day2.Command.Parser
  alias Aoc2021.Day2.Submarine1
  alias Aoc2021.Day2.Submarine2

  @doc """
  Produce a stream of commands from the input file.
  """
  @spec read_input :: Enum.t()
  def read_input() do
    File.stream!("priv/day2/input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.reject(fn line -> line == "" end)
    |> Stream.map(&Parser.parse_command/1)
  end

  @spec solve_part1 :: non_neg_integer()
  def solve_part1() do
    read_input()
    |> Enum.reduce(Submarine1.new(), &Submarine1.apply/2)
    |> multiply()
  end

  @spec solve_part2 :: non_neg_integer()
  def solve_part2() do
    read_input()
    |> Enum.reduce(Submarine2.new(), &Submarine2.apply/2)
    |> multiply()
  end

  @spec multiply(Submarine1.t()) :: non_neg_integer()
  @spec multiply(Submarine2.t()) :: non_neg_integer()
  def multiply(%{horizontal: h, depth: d}), do: h * d
end
