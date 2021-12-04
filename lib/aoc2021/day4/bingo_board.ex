defmodule Aoc2021.Day4.BingoBoard do
  @moduledoc """
  A 5x5 bingo board containing numbers and marked positions.
  """

  defmodule Position do
    @moduledoc """
    A position on the bingo board.
    """
    @type row() :: non_neg_integer()
    @type col() :: non_neg_integer()
    @opaque t() :: {row(), col()}

    @spec new(row(), col()) :: t()
    def new(row, col), do: {row, col}

    @spec row(t()) :: row()
    def row({row, _}), do: row

    @spec col(t()) :: col()
    def col({_, col}), do: col
  end

  @opaque board() :: %{non_neg_integer() => Position.t()}

  defstruct [:board, :marked]

  @opaque t() :: %__MODULE__{
            board: board(),
            marked: MapSet.t(Position.t())
          }

  @spec new([[non_neg_integer()]]) :: t()
  def new(numbers) do
    board =
      numbers
      |> Enum.with_index()
      |> Enum.reduce(%{}, &new_row/2)

    %__MODULE__{board: board, marked: MapSet.new()}
  end

  @spec play(t(), non_neg_integer()) :: t()
  def play(board, number) do
    case Map.get(board.board, number) do
      pos when is_tuple(pos) ->
        %__MODULE__{board | marked: MapSet.put(board.marked, pos)}

      nil ->
        board
    end
  end

  @spec win?(t()) :: boolean()
  def win?(board) do
    Enum.any?(
      winning_positions(),
      fn positions ->
        MapSet.subset?(positions, board.marked)
      end
    )
  end

  @spec score(t(), non_neg_integer()) :: non_neg_integer()
  def score(board, number) do
    sum =
      board.board
      |> Map.to_list()
      |> Enum.reject(fn {_, v} -> MapSet.member?(board.marked, v) end)
      |> Enum.map(fn {v, _} -> v end)
      |> Enum.sum()

    sum * number
  end

  defp new_row({numbers, row}, acc) do
    {acc, _} =
      numbers
      |> Enum.with_index()
      |> Enum.reduce({acc, row}, &new_cell/2)

    acc
  end

  defp new_cell({number, col}, {acc, row}) do
    acc = Map.put(acc, number, Position.new(row, col))
    {acc, row}
  end

  def winning_positions, do: winning_rows() ++ winning_cols()

  def winning_rows do
    for row <- 0..4 do
      MapSet.new(
        for col <- 0..4 do
          Position.new(row, col)
        end
      )
    end
  end

  def winning_cols do
    for col <- 0..4 do
      MapSet.new(
        for row <- 0..4 do
          Position.new(row, col)
        end
      )
    end
  end
end
