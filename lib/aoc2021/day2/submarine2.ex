defmodule Aoc2021.Day2.Submarine2 do
  defstruct [:horizontal, :depth, :aim]

  alias Aoc2021.Day2.Command

  @type t() :: %__MODULE__{
          horizontal: non_neg_integer(),
          depth: non_neg_integer(),
          aim: integer()
        }

  @spec new :: t()
  def new do
    %__MODULE__{horizontal: 0, depth: 0, aim: 0}
  end

  @spec apply(Command.t(), t()) :: t()
  def apply({:forward, x}, submarine) do
    sub = %__MODULE__{
      submarine
      | horizontal: submarine.horizontal + x,
        depth: submarine.depth + submarine.aim * x
    }

    if sub.depth < 0 do
      IO.inspect(sub)
    end

    sub
  end

  def apply({:down, x}, submarine) do
    %__MODULE__{submarine | aim: submarine.aim + x}
  end

  def apply({:up, x}, submarine) do
    %__MODULE__{submarine | aim: submarine.aim - x}
  end
end
