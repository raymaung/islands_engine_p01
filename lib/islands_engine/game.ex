defmodule IslandsEngine.Game do

  alias IslandsEngine.{Board, Coordinate, Guesses, Island, Rules}

  @rules  Application.get_env(:islands_engine, :rules)

  @players [:player1, :player2]

  def new(name) do
    player1 = %{name: name, board: Board.new(), guesses: Guesses.new()}
    player2 = %{name: nil, board: Board.new(), guesses: Guesses.new()}

    %{
      player1: player1,
      player2: player2,
      rules: %Rules{}
    }
  end

  def add_player(game = %{}, name) when is_binary(name) do
    with {:ok, rules} <- @rules.check(game.rules, :add_player) do
      game
      |> update_player2_name(name)
      |> update_rules(rules)
      |> return_ok()
    else
      :error -> return_error(game)
    end
  end

  def position_island(game, player, key, row, col) when player in @players do
    with board <- player_board(game, player),
      {:ok, rules} <- @rules.check(game.rules, {:position_islands, player}),
      {:ok, coordinate} <- Coordinate.new(row, col),
      {:ok, island} <- Island.new(key, coordinate),
      %{} = board <- Board.position_island(board, key, island)
    do
      game
      |> update_board(player, board)
      |> update_rules(rules)
      |> return_ok()
    else
      :error ->
        return_error(game)

      {:error, :invalid_coordinate} ->
        return_error(game, :invalid_coordinate)

      {:error, :invalid_island_type} ->
        return_error(game, :invalid_island_type)
    end
  end

  def set_islands(game, player) do
    board = player_board(game, player)
    with {:ok, rules} <- @rules.check(game.rules, {:set_islands, player}),
      true <- Board.all_islands_positioned?(board) do
      game
      |> update_rules(rules)
      |> return_ok()
    else
      :error -> return_error(game)
      false -> return_error(game, :not_all_islands_positioned)
    end
  end

  def guess_coordinate(game, player_key, row, col) do
    opponent_key = opponent(player_key)
    opponent_board = player_board(game, opponent_key)

    with {:ok, rules} <- @rules.check(game.rules, {:guess_coordinate, player_key}),
      {:ok, coordinate} <- Coordinate.new(row, col),
      {hit_or_miss, forested_island, win_status, opponent_board} <- Board.guess(opponent_board, coordinate),
      {:ok, rules} <- @rules.check(rules, {:win_check, win_status}) do
        game
        |> update_board(opponent_key, opponent_board)
        |> update_guesses(player_key, hit_or_miss, coordinate)
        |> update_rules(rules)
        |> return_ok({hit_or_miss, forested_island, win_status})
      else
        :error -> return_error(game)
        {:error, :invalid_coordinate} -> return_error(game, :invalid_coordinate)
      end
  end

  defp update_board(game, player, board) do
    Map.update!(game, player, fn player -> %{player | board: board} end)
  end

  defp player_board(game, player) do
    Map.get(game, player).board
  end

  defp update_player2_name(game, name) do
    put_in(game.player2.name, name)
  end

  defp update_rules(game, rules) do
    %{game | rules: rules}
  end

  defp return_ok(game), do: {:ok, game}
  defp return_ok(game, ret), do: {:ok, game, ret}

  defp return_error(game), do: {:error, game}
  defp return_error(game, reason), do: {:error, game, reason}

  defp opponent(:player1), do: :player2
  defp opponent(:player2), do: :player1

  defp update_guesses(game, player_key, hit_or_miss, coordinate) do
    update_in(game, [player_key, :guesses], fn guesses ->
      Guesses.add(guesses, hit_or_miss, coordinate)
    end)
  end
end
