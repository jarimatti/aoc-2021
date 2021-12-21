defmodule Aoc2021.Day16 do
  @moduledoc """
  See https://adventofcode.com/2021/day/16
  """

  alias Aoc2021.Day16.Packet

  @type operator() :: :literal | :sum | :prod | :min | :max | :gt | :lt | :eq

  defmodule Packet do
    @moduledoc false

    alias Aoc2021.Day16

    defstruct [:version, :type, :value]

    @type t() :: %__MODULE__{
            version: non_neg_integer(),
            type: Day16.operator(),
            value: t()
          }

    @spec new(non_neg_integer(), :literal, non_neg_integer()) :: t()
    @spec new(non_neg_integer(), Day16.operator(), [t()]) :: t()
    def new(version, :literal, value) do
      %__MODULE__{version: version, type: :literal, value: value}
    end

    def new(version, op, [_ | _] = contents) when op in [:sum, :prod, :min, :max] do
      %__MODULE__{version: version, type: op, value: contents}
    end

    def new(version, op, [_, _] = contents) when op in [:gt, :lt, :eq] do
      %__MODULE__{version: version, type: op, value: contents}
    end
  end

  defmodule Parser do
    @moduledoc false

    alias Aoc2021.Day16.Packet

    def parse_packet(<<v::3, 4::3, rest::bitstring>>) do
      # literal packet
      {value, rest} = parse_value(rest)
      {Packet.new(v, :literal, value), rest}
    end

    def parse_packet(<<v::3, t::3, 0::1, bits::15, rest::bitstring>>) do
      <<contents::bitstring-size(bits), rest::bitstring>> = rest
      ps = parse_until_empty(contents, [])
      {Packet.new(v, parse_type(t), ps), rest}
    end

    def parse_packet(<<v::3, t::3, 1::1, count::11, rest::bitstring>>) do
      {ps, rest} = parse_until_count(rest, count, [])
      {Packet.new(v, parse_type(t), ps), rest}
    end

    defp parse_value(rest), do: parse_value(rest, <<>>)

    defp parse_value(<<0::1, v::bitstring-size(4), rest::bitstring>>, acc) do
      bin = <<acc::bitstring, v::bitstring>>
      len = bit_size(bin)
      <<value::integer-size(len)>> = bin
      {value, rest}
    end

    defp parse_value(<<1::1, v::bitstring-size(4), rest::bitstring>>, acc) do
      parse_value(rest, <<acc::bitstring, v::bitstring>>)
    end

    defp parse_type(0), do: :sum
    defp parse_type(1), do: :prod
    defp parse_type(2), do: :min
    defp parse_type(3), do: :max
    defp parse_type(4), do: :literal
    defp parse_type(5), do: :gt
    defp parse_type(6), do: :lt
    defp parse_type(7), do: :eq

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

  defmodule Evaluator do
    @moduledoc false

    alias Aoc2021.Day16.Packet

    @spec evaluate(Packet.t()) :: non_neg_integer()
    def evaluate(%Packet{type: t, value: v}) do
      evaluate(t, v)
    end

    defp evaluate(:literal, v), do: v

    defp evaluate(:sum, vv) do
      vv
      |> Enum.map(&evaluate/1)
      |> Enum.sum()
    end

    defp evaluate(:prod, vv) do
      vv
      |> Enum.map(&evaluate/1)
      |> Enum.product()
    end

    defp evaluate(:min, vv) do
      vv
      |> Enum.map(&evaluate/1)
      |> Enum.min()
    end

    defp evaluate(:max, vv) do
      vv
      |> Enum.map(&evaluate/1)
      |> Enum.max()
    end

    defp evaluate(:gt, [a, b]) do
      if evaluate(a) > evaluate(b) do
        1
      else
        0
      end
    end

    defp evaluate(:lt, [a, b]) do
      if evaluate(a) < evaluate(b) do
        1
      else
        0
      end
    end

    defp evaluate(:eq, [a, b]) do
      if evaluate(a) == evaluate(b) do
        1
      else
        0
      end
    end
  end

  @spec solve_part1() :: non_neg_integer()
  @spec solve_part1(Path.t()) :: non_neg_integer()
  def solve_part1(path \\ "priv/day16/input.txt") do
    path
    |> File.read!()
    |> parse_and_sum()
  end

  @spec solve_part2() :: non_neg_integer()
  @spec solve_part2(Path.t()) :: non_neg_integer()
  def solve_part2(path \\ "priv/day16/input.txt") do
    path
    |> File.read!()
    |> parse()
    |> Evaluator.evaluate()
  end

  defp parse(string) do
    {p, _} =
      string
      |> Base.decode16!()
      |> Parser.parse_packet()

    p
  end

  def parse_and_sum(string) do
    string
    |> parse()
    |> sum_versions()
  end

  def sum_versions(%Packet{version: v, type: :literal}) do
    v
  end

  def sum_versions(%Packet{version: v, value: packets}) do
    v + Enum.reduce(packets, 0, fn p, acc -> acc + sum_versions(p) end)
  end
end
