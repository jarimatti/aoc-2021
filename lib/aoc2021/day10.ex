defmodule Aoc2021.Day10 do
  @moduledoc """
  See https://adventofcode.com/2021/day/10
  """

  @illegal_scores %{
    ?) => 3,
    ?] => 57,
    ?} => 1197,
    ?> => 25_137
  }

  @type token() :: char()

  defmodule Reader do
    @moduledoc false

    @spec read_input(Path.t()) :: [[Aoc2021.Day10.token()]]
    def read_input(path) do
      path
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.reject(&empty_line?/1)
      |> Stream.map(&tokens/1)
      |> Enum.to_list()
    end

    defp empty_line?(""), do: true
    defp empty_line?(_), do: false

    defp tokens(line) do
      String.to_charlist(line)
    end
  end

  defmodule Parser do
    @moduledoc false

    @spec parse([Aoc2021.Day10.token()]) ::
            :ok
            | :incomplete
            | {:error, {:unexpected_token, Aoc2021.Day10.token(), non_neg_integer()}}
    def parse(line) do
      result =
        line
        |> Enum.with_index()
        |> Enum.reduce_while([], &step/2)

      case result do
        [] -> :ok
        [_ | _] -> :incomplete
        {:error, reason} -> {:error, reason}
      end
    end

    defp step({token, _pos}, stack) when token in [?(, ?{, ?[, ?<],
      do: {:cont, [token | stack]}

    defp step({?), _pos}, [?( | rest]), do: {:cont, rest}
    defp step({?}, _pos}, [?{ | rest]), do: {:cont, rest}
    defp step({?], _pos}, [?[ | rest]), do: {:cont, rest}
    defp step({?>, _pos}, [?< | rest]), do: {:cont, rest}
    defp step({token, pos}, _stack), do: {:halt, {:error, {:unexpected_token, token, pos}}}
  end

  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day10/input.txt") do
    path
    |> Reader.read_input()
    |> Enum.map(&Parser.parse/1)
    |> Enum.map(&error_score/1)
    |> Enum.sum()
  end

  defp error_score({:error, {:unexpected_token, token, _pos}}) do
    Map.get(@illegal_scores, token, 0)
  end

  defp error_score(_), do: 0

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(_path \\ "priv/day10/input.txt") do
    # stub
    0
  end
end
