defmodule Aoc2021.Day16.ParserTest do
  use ExUnit.Case, async: true
  doctest Aoc2021.Day16.Parser

  alias Aoc2021.Day16.Packet
  alias Aoc2021.Day16.Parser

  test "parse literal value" do
    bin = Base.decode16!("D2FE28")

    {packet, rest} = Parser.parse_packet(bin)

    assert packet == Packet.new(6, :literal, 2021)
    assert rest == <<0::3>>
  end

  test "parse operator with bit length" do
    bin = Base.decode16!("38006F45291200")

    {packet, rest} = Parser.parse_packet(bin)

    expected =
      Packet.new(
        1,
        :lt,
        [
          Packet.new(6, :literal, 10),
          Packet.new(2, :literal, 20)
        ]
      )

    assert packet == expected
    assert rest == <<0::7>>
  end

  test "parse operator with count length" do
    bin = Base.decode16!("EE00D40C823060")

    {packet, rest} = Parser.parse_packet(bin)

    expected =
      Packet.new(
        7,
        :max,
        [
          Packet.new(2, :literal, 1),
          Packet.new(4, :literal, 2),
          Packet.new(1, :literal, 3)
        ]
      )

    assert packet == expected
    assert rest == <<0::5>>
  end
end
