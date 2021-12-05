defmodule Aoc2021.Day5.Parser do
  @moduledoc """
  Parse lines from puzzle input
  """

  alias Aoc2021.Day5.Line
  alias Aoc2021.Day5.Point

  @spec parse(Enum.t()) :: [Line.t()]
  def parse(stream) do
    stream
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&empty_line?/1)
    |> Stream.map(&read_line/1)
    |> Enum.to_list()
  end

  defp empty_line?(""), do: true
  defp empty_line?(_), do: false

  defp read_line(line) do
    [a, b] =
      line
      |> String.split(" -> ")
      |> Enum.map(&read_point/1)

    Line.new(a, b)
  end

  defp read_point(string) do
    [x, y] =
      string
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    Point.new(x, y)
  end
end
