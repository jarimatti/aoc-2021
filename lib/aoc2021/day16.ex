defmodule Aoc2021.Day16 do
  @moduledoc """
  See https://adventofcode.com/2021/day/16
  """

  alias Aoc2021.Day16.Packet

  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day16/input.txt") do
    path
    |> File.read!()
    |> parse_and_sum()
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(_path \\ "priv/day16/input.txt") do
    # stub
    0
  end

  defmodule Packet do
    @moduledoc false

    defstruct [:version, :type, :value]

    def new(version, :literal) do
      %__MODULE__{version: version, type: :literal, value: nil}
    end

    def new(version, :operator, contents) do
      %__MODULE__{version: version, type: :operator, value: contents}
    end
  end

  defmodule Parser do
    @moduledoc false

    alias Aoc2021.Day16.Packet

    def parse_packet(<<v::3, 4::3, rest::bitstring>>) do
      # literal packet
      {Packet.new(v, :literal), skip_literal(rest)}
    end

    def parse_packet(<<v::3, _::3, 0::1, bits::15, rest::bitstring>>) do
      <<contents::bitstring-size(bits), rest::bitstring>> = rest
      ps = parse_until_empty(contents, [])
      {Packet.new(v, :operator, ps), rest}
    end

    def parse_packet(<<v::3, _::3, 1::1, count::11, rest::bitstring>>) do
      {ps, rest} = parse_until_count(rest, count, [])
      {Packet.new(v, :operator, ps), rest}
    end

    defp skip_literal(<<1::1, _::4, rest::bitstring>>), do: skip_literal(rest)
    defp skip_literal(<<0::1, _::4, rest::bitstring>>), do: rest

    defp parse_until_empty(<<>>, acc), do: Enum.reverse(acc)

    defp parse_until_empty(rest, acc) do
      {p, rest} = parse_packet(rest)
      parse_until_empty(rest, [p | acc])
    end

    defp parse_until_count(rest, 0, acc), do: {Enum.reverse(acc), rest}

    defp parse_until_count(rest, count, acc) do
      {p, rest} = parse_packet(rest)
      parse_until_count(rest, count - 1, [p | acc])
    end
  end

  def parse_and_sum(string) do
    {p, _} =
      string
      |> Base.decode16!()
      |> Parser.parse_packet()

    sum_versions(p)
  end

  def sum_versions(%Packet{version: v, type: :literal}) do
    v
  end

  def sum_versions(%Packet{version: v, type: :operator, value: packets}) do
    v + Enum.reduce(packets, 0, fn p, acc -> acc + sum_versions(p) end)
  end
end
