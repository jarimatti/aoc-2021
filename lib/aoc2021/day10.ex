defmodule Aoc2021.Day10 do
  @moduledoc """
  See https://adventofcode.com/2021/day/10
  """

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
            | {:incomplete, [Aoc2021.Day10.token()]}
            | {:error, {:unexpected_token, Aoc2021.Day10.token(), non_neg_integer()}}
    def parse(line) do
      result =
        line
        |> Enum.with_index()
        |> Enum.reduce_while([], &step/2)

      case result do
        [] -> :ok
        [_ | _] = stack -> {:incomplete, stack}
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
    error_token_score(token)
  end

  defp error_score(_), do: 0

  defp error_token_score(?)), do: 3
  defp error_token_score(?]), do: 57
  defp error_token_score(?}), do: 1197
  defp error_token_score(?>), do: 25_137

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(path \\ "priv/day10/input.txt") do
    path
    |> Reader.read_input()
    |> Enum.map(&Parser.parse/1)
    |> Enum.filter(&incomplete?/1)
    |> Enum.map(&autocomplete_score/1)
    |> median()
  end

  defp median(scores) do
    scores
    |> Enum.sort()
    |> Enum.at(div(length(scores), 2))
  end

  defp incomplete?({:incomplete, _}), do: true
  defp incomplete?(_), do: false

  defp autocomplete_score({:incomplete, stack}) do
    Enum.reduce(stack, 0, &autocomplete_token_score/2)
  end

  defp autocomplete_token_score(token, acc) do
    score = token |> closing_token() |> incomplete_token_score()

    5 * acc + score
  end

  defp incomplete_token_score(?)), do: 1
  defp incomplete_token_score(?]), do: 2
  defp incomplete_token_score(?}), do: 3
  defp incomplete_token_score(?>), do: 4

  defp closing_token(?(), do: ?)
  defp closing_token(?[), do: ?]
  defp closing_token(?{), do: ?}
  defp closing_token(?<), do: ?>
end
