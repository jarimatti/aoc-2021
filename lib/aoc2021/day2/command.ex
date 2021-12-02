defmodule Aoc2021.Day2.Command do
  @type t() :: {:forward | :down | :up, non_neg_integer()}

  defmodule Parser do
    alias Aoc2021.Day2.Command

    @spec parse_command(binary()) :: Command.t()
    def parse_command("forward " <> number) do
      make_command(:forward, number)
    end

    def parse_command("up " <> number) do
      make_command(:up, number)
    end

    def parse_command("down " <> number) do
      make_command(:down, number)
    end

    defp make_command(instruction, number) do
      {amount, _} = Integer.parse(number)
      {instruction, amount}
    end
  end
end
