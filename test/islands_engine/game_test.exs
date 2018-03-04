defmodule IslandsEngine.GameTest do
  use ExUnit.Case

  alias IslandsEngine.Game

  @tag :wip
  test "xxx" do
    {:ok, game} = Game.start_link("Dino")
    Game.add_player(game, "Pebbles")

    {:error, :not_all_islands_positioned} = Game.set_islands(game, :player1)

    :ok = Game.position_island(game, :player1, :atoll, 1, 1)
    :ok = Game.position_island(game, :player1, :dot, 1, 4)
    :ok = Game.position_island(game, :player1, :l_shape, 1, 5)
    :ok = Game.position_island(game, :player1, :s_shape, 5, 1)
    :ok = Game.position_island(game, :player1, :square, 5, 5)

    assert {:ok, %{atoll: _}} = Game.set_islands(game, :player1)
  end
end
