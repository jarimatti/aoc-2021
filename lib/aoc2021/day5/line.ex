defmodule Aoc2021.Day5.Line do
  @moduledoc """
  A line identified by endpoints.
  """

  alias Aoc2021.Day5.Point

  @opaque t() :: {Point.t(), Point.t()}

  @spec new(Point.t(), Point.t()) :: t()
  def new(a, b) do
    [sa, sb] = Enum.sort([a, b])
    {sa, sb}
  end

  @spec a(t()) :: Point.t()
  def a({a0, _}), do: a0

  @spec b(t()) :: Point.t()
  def b({_, b0}), do: b0

  @doc """
  Get the points that the line crosses.
  """
  @spec points(t()) :: [Point.t()]
  def points(line) do
    case orientation(line) do
      o when o in [:horizontal, :vertical] -> horizontal_vertical_points(line)
      :diagonal -> diagonal_points(line)
    end
  end

  defp horizontal_vertical_points({a, b}) do
    for x <- Point.x(a)..Point.x(b), y <- Point.y(a)..Point.y(b) do
      Point.new(x, y)
    end
  end

  defp diagonal_points({a, b}) do
    ys = Point.y(a)..Point.y(b)
    xs = Point.x(a)..Point.x(b)

    [xs, ys]
    |> Enum.zip()
    |> Enum.map(fn {x, y} -> Point.new(x, y) end)
  end

  @spec orientation(t()) :: :horizontal | :vertical | :diagonal
  def orientation({a, b}) do
    case {Point.to_tuple(a), Point.to_tuple(b)} do
      {{x, _}, {x, _}} -> :vertical
      {{_, y}, {_, y}} -> :horizontal
      _ -> :diagonal
    end
  end
end
