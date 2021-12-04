defmodule Aoc2021.Day4 do
  @moduledoc """
  See https://adventofcode.com/2021/day/4
  """

  alias Aoc2021.Day4.BingoBoard
  alias Aoc2021.Day4.Parser

  def solve_part1(path \\ "priv/day4/input.txt") do
    {numbers, boards} =
      path
      |> File.stream!()
      |> Parser.parse()

    {winner, number} = Enum.reduce_while(numbers, boards, &play/2)
    BingoBoard.score(winner, number)
  end

  def solve_part2(path \\ "priv/day4/input.txt") do
    {numbers, boards} =
      path
      |> File.stream!()
      |> Parser.parse()

    {_, winners} = Enum.reduce(numbers, {boards, []}, &play2/2)
    {winner, number} = hd(winners)

    BingoBoard.score(winner, number)
  end

  def play(number, boards) do
    boards = Enum.map(boards, &BingoBoard.play(&1, number))

    case Enum.find(boards, &BingoBoard.win?/1) do
      nil -> {:cont, boards}
      winner -> {:halt, {winner, number}}
    end
  end

  def play2(number, {boards, winners}) do
    {new_winners, boards} =
      boards
      |> Enum.map(&BingoBoard.play(&1, number))
      |> Enum.split_with(&BingoBoard.win?/1)

    new_winners = Enum.map(new_winners, fn w -> {w, number} end)

    {boards, new_winners ++ winners}
  end
end
