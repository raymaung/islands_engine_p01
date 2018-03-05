defmodule IslandsEngine.GameTest do
  use ExUnit.Case

  alias IslandsEngine.{Game, Rules}

  @tag :wip
  test "verify guess coordinate" do
    {:ok, game} = Game.start_link("Miles")
    :error = Game.guess_coordinate(game, :player1, 1, 1)
    :ok = Game.add_player(game, "Trane")
    :ok = Game.position_island(game, :player1, :dot, 1, 1)
    :ok = Game.position_island(game, :player2, :square, 1, 1)
    state_data = :sys.get_state(game)

    state_data = :sys.replace_state(game, fn data ->
      %{state_data | rules: %Rules{state: :player1_turn}}
    end)

    {:miss, :none, :no_win} = Game.guess_coordinate(game, :player1, 5, 5)
    :error = Game.guess_coordinate(game, :player1, 3, 1)
    {:hit, :dot, :win} = Game.guess_coordinate(game, :player2, 1, 1)
  end

  test "verify set_islands" do
    {:ok, game} = Game.start_link("Dino")
    Game.add_player(game, "Pebbles")

    {:error, :not_all_islands_positioned} = Game.set_islands(game, :player1)

    :ok = Game.position_island(game, :player1, :atoll, 1, 1)
    :ok = Game.position_island(game, :player1, :dot, 1, 4)
    :ok = Game.position_island(game, :player1, :l_shape, 1, 5)
    :ok = Game.position_island(game, :player1, :s_shape, 5, 1)
    :ok = Game.position_island(game, :player1, :square, 5, 5)

    {:ok, %{atoll: _}} = Game.set_islands(game, :player1)
  end
end
