defmodule Aoc2021.Day4.Process.Board do
  use GenServer

  alias Aoc2021.Day4.BingoBoard

  def start_link(board) do
    GenServer.start_link(__MODULE__, board)
  end

  @spec play_number(GenServer.server(), non_neg_integer()) :: :ok
  def play_number(server, number) do
    GenServer.cast(server, {:number, number})
  end

  @spec end_game(GenServer.server()) :: {:ok, :no_bingo | {:bingo, score, round}}
        when round: non_neg_integer(), score: non_neg_integer()
  def end_game(server) do
    GenServer.call(server, :end)
  end

  @impl GenServer
  def init(board) do
    {:ok, %{board: board, round: 0, state: :game_on}}
  end

  @impl GenServer
  def handle_cast({:number, number}, %{board: board, round: round, state: :game_on}) do
    board = BingoBoard.play(board, number)
    round = round + 1

    state =
      case BingoBoard.win?(board) do
        true ->
          %{board: board, round: round, score: BingoBoard.score(board, number), state: :win}

        false ->
          %{board: board, round: round, state: :game_on}
      end

    {:noreply, state}
  end

  def handle_cast({:number, _}, %{state: :win} = state) do
    {:noreply, state}
  end

  @impl GenServer
  def handle_call(:end, _from, %{state: :game_on} = state) do
    # {:stop, :normal, :no_bingo, state}
    {:reply, :no_bingo, state}
  end

  def handle_call(:end, _from, %{score: score, round: round, state: :win} = state) do
    # {:stop, :normal, {:bingo, score, round}, state}
    {:reply, {:bingo, score, round}, state}
  end

  @impl GenServer
  def terminate(reason, state) do
    IO.puts("Board terminating. #{inspect(%{pid: self(), reason: reason, state: state})}")
  end
end
