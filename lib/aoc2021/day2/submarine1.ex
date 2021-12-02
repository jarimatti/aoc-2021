defmodule Aoc2021.Day2.Submarine1 do
  defstruct [:horizontal, :depth]

  alias Aoc2021.Day2.Command

  @type t() :: %__MODULE__{horizontal: non_neg_integer(), depth: non_neg_integer()}

  @spec new :: t()
  def new do
    %__MODULE__{horizontal: 0, depth: 0}
  end

  @spec apply(Command.t(), t()) :: t()
  def apply({:forward, x}, submarine) do
    %__MODULE__{submarine | horizontal: submarine.horizontal + x}
  end

  def apply({:down, x}, submarine) do
    %__MODULE__{submarine | depth: submarine.depth + x}
  end

  def apply({:up, x}, submarine) do
    %__MODULE__{submarine | depth: submarine.depth - x}
  end
end
