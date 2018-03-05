defmodule IslandsEngine.ServerTest do
  use ExUnit.Case

  alias IslandsEngine.{Server, Rules}

  test "verify guess coordinate" do
    {:ok, game} = Server.start_link("Miles")
    :error = Server.guess_coordinate(game, :player1, 1, 1)
    :ok = Server.add_player(game, "Trane")
    :ok = Server.position_island(game, :player1, :dot, 1, 1)
    :ok = Server.position_island(game, :player2, :square, 1, 1)
    state_data = :sys.get_state(game)

    state_data = :sys.replace_state(game, fn data ->
      %{state_data | rules: %Rules{state: :player1_turn}}
    end)

    {:miss, :none, :no_win} = Server.guess_coordinate(game, :player1, 5, 5)
    :error = Server.guess_coordinate(game, :player1, 3, 1)
    {:hit, :dot, :win} = Server.guess_coordinate(game, :player2, 1, 1)
  end

  test "verify set_islands" do
    {:ok, game} = Server.start_link("Dino")
    Server.add_player(game, "Pebbles")

    {:error, :not_all_islands_positioned} = Server.set_islands(game, :player1)

    :ok = Server.position_island(game, :player1, :atoll, 1, 1)
    :ok = Server.position_island(game, :player1, :dot, 1, 4)
    :ok = Server.position_island(game, :player1, :l_shape, 1, 5)
    :ok = Server.position_island(game, :player1, :s_shape, 5, 1)
    :ok = Server.position_island(game, :player1, :square, 5, 5)

    {:ok, %{atoll: _}} = Server.set_islands(game, :player1)
  end
end
