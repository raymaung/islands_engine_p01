defmodule IslandsEngine.GameTest do
  use ExUnit.Case

  alias IslandsEngine.Game

  @error_rules %{error: :error}

  test "add players" do
    game = Game.new("John")
    {:ok, game} = Game.add_player(game, "Richard")
    assert game.player1.name == "John"
    assert game.player2.name == "Richard"
  end

  test "return error on adding player when the rules does not allow it" do
    game = Game.new("John")
    game = %{ game | rules: @error_rules }

    assert {:error, game} == Game.add_player(game, "Richard")
  end
end
