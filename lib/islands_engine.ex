defmodule IslandsEngine do

  alias IslandsEngine.Server

  def new_game(name) do
    Server.start_link(name)
  end

  def add_player(game_pid, player_name) do
    GenServer.call(game_pid, {:add_player, player_name})
  end

  def position_island(game_pid, player_key, island_key, row, col) do
    GenServer.call(game_pid, {:position_island, player_key, island_key, row, col})
  end

  def set_islands(game_pid, player_key) do
    GenServer.call(game_pid, {:set_islands, player_key})
  end

  def guess_coordinate(game_pid, player_key, row, col) do
    GenServer.call(game_pid, {:guess_coordinate, player_key, row, col})
  end
end
