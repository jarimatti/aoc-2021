defmodule Aoc2021.Day4.Parser do
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
