defmodule Aoc2021.Day5.Point do
  @moduledoc """
  An (x, y) coordinate point on the chart.
  """

  @type x() :: non_neg_integer()
  @type y() :: non_neg_integer()
  @opaque t() :: {x(), y()}

  @spec new(x(), y()) :: t()
  def new(x, y) do
    {x, y}
  end

  @spec x(t()) :: x()
  def x({x0, _}), do: x0

  @spec y(t()) :: y()
  def y({_, y0}), do: y0

  @spec to_tuple(t()) :: {x(), y()}
  def to_tuple(p), do: p
end
