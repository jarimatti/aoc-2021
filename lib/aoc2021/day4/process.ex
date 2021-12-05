defmodule Aoc2021.Day4.Process do
  @moduledoc """
  Run each board in their own process.
  """

  alias Aoc2021.Day4.Parser
  alias Aoc2021.Day4.Process.Board

  def solve_part1(path \\ "priv/day4/input.txt") do
    {numbers, boards} =
      path
      |> File.stream!()
      |> Parser.parse()

    {:bingo, score, _round} =
      play_all(numbers, boards)
      |> Enum.filter(fn
        {:bingo, _, _} -> true
        :no_bingo -> false
      end)
      |> Enum.min_by(fn {_, _, round} -> round end)

    score
  end

  def solve_part2(path \\ "priv/day4/input.txt") do
    {numbers, boards} =
      path
      |> File.stream!()
      |> Parser.parse()

    {:bingo, score, _round} =
      play_all(numbers, boards)
      |> Enum.filter(fn
        {:bingo, _, _} -> true
        :no_bingo -> false
      end)
      |> Enum.max_by(fn {_, _, round} -> round end)

    score
  end

  def play_all(numbers, boards) do
    {:ok, supervisor} =
      DynamicSupervisor.start_link(
        strategy: :one_for_one,
        name: Aoc2021.Day4.Process.BoardSupervisor
      )

    pids =
      Enum.map(boards, fn board ->
        {:ok, pid} =
          DynamicSupervisor.start_child(
            Aoc2021.Day4.Process.BoardSupervisor,
            {Aoc2021.Day4.Process.Board, board}
          )

        pid
      end)

    Enum.each(numbers, fn number ->
      Enum.each(pids, fn pid ->
        Board.play_number(pid, number)
      end)
    end)

    results =
      Enum.map(pids, fn pid ->
        Board.end_game(pid)
      end)

    DynamicSupervisor.stop(supervisor)

    results
  end
end
