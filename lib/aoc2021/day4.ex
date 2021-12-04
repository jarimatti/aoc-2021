defmodule Aoc2021.Day4 do
  @moduledoc """
  See https://adventofcode.com/2021/day/4
  """

  alias Aoc2021.Day4.BingoBoard

  defmodule Parser do
    @moduledoc """
    Parse the bingo game (numbers and boards) from input stream.
    """
    alias Aoc2021.Day4.BingoBoard

    @spec read_numbers(String.t()) :: [non_neg_integer()]
    defp read_numbers(line) do
      read_numbers(line, fn s -> String.split(s, ",") end)
    end

    defp read_numbers(line, splitter) do
      line
      |> String.trim()
      |> splitter.()
      |> Enum.map(&String.to_integer/1)
    end

    @spec parse(Enum.t()) :: {[non_neg_integer()], [BingoBoard.t()]}
    def parse(stream) do
      [[number_string] | boards] =
        stream
        |> Stream.map(&String.trim/1)
        |> Stream.chunk_by(&empty_line?/1)
        |> Stream.reject(&empty_chunk?/1)
        |> Enum.to_list()

      {read_numbers(number_string), Enum.map(boards, &read_board/1)}
    end

    @spec read_board([String.t()]) :: BingoBoard.t()
    defp read_board(lines) do
      lines
      |> Enum.map(&read_line/1)
      |> BingoBoard.new()
    end

    defp read_line(line) do
      read_numbers(line, fn s -> String.split(s) end)
    end

    @spec empty_line?(String.t()) :: boolean
    defp empty_line?(""), do: true
    defp empty_line?(_), do: false

    defp empty_chunk?([""]), do: true
    defp empty_chunk?(_), do: false
  end

  def solve_part1(path \\ "priv/day4/input.txt") do
    {numbers, boards} =
      File.stream!(path)
      |> Parser.parse()

    {winner, number} = Enum.reduce_while(numbers, boards, &play/2)
    BingoBoard.score(winner, number)
  end

  def solve_part2(path \\ "priv/day4/input.txt") do
    {numbers, boards} =
      File.stream!(path)
      |> Parser.parse()

    {_, winners} = Enum.reduce(numbers, {boards, []}, &play2/2)
    {winner, number} = hd(winners)

    IO.inspect(winners)
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
