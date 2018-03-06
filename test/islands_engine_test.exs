defmodule IslandsEngineTest do
  use ExUnit.Case

  alias IslandsEngine.Rules

  test "verify guess coordinate" do
    {:ok, game} = IslandsEngine.new_game("Miles")
    :error = IslandsEngine.guess_coordinate(game, :player1, 1, 1)
    :ok = IslandsEngine.add_player(game, "Trane")
    :ok = IslandsEngine.position_island(game, :player1, :dot, 1, 1)
    :ok = IslandsEngine.position_island(game, :player2, :square, 1, 1)

    :sys.replace_state(game, fn data ->
      %{data | rules: %Rules{state: :player1_turn}}
    end)

    {:miss, :none, :no_win} = IslandsEngine.guess_coordinate(game, :player1, 5, 5)
    :error = IslandsEngine.guess_coordinate(game, :player1, 3, 1)
    {:hit, :dot, :win} = IslandsEngine.guess_coordinate(game, :player2, 1, 1)
  end

  test "verify set_islands" do
    {:ok, game} = IslandsEngine.new_game("Dino")
    :ok = IslandsEngine.add_player(game, "Pebbles")

    {:error, :not_all_islands_positioned} = IslandsEngine.set_islands(game, :player1)

    :ok = IslandsEngine.position_island(game, :player1, :atoll, 1, 1)
    :ok = IslandsEngine.position_island(game, :player1, :dot, 1, 4)
    :ok = IslandsEngine.position_island(game, :player1, :l_shape, 1, 5)
    :ok = IslandsEngine.position_island(game, :player1, :s_shape, 5, 1)
    :ok = IslandsEngine.position_island(game, :player1, :square, 5, 5)

    :ok = IslandsEngine.set_islands(game, :player1)
  end
end
