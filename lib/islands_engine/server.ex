defmodule IslandsEngine.Server do
  use GenServer

  alias IslandsEngine.Game

  def start_link(name) when is_binary(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def via_tuple(name), do: {:via, Registry, {Registry.Game, name}}

  def init(name) do
    {:ok, Game.new(name) }
  end

  def handle_call({:add_player, name}, _from, game) do
    game
    |> Game.add_player(name)
    |> reply()
  end

  def handle_call({:position_island, player, player_key, row, col}, _from, game) do
    game
    |> Game.position_island(player, player_key, row, col)
    |> reply()
  end

  def handle_call({:set_islands, player_key}, _from, game) do
    game
    |> Game.set_islands(player_key)
    |> reply()
  end

  def handle_call({:guess_coordinate, player_key, row, col}, _from, game) do
    game
    |> Game.guess_coordinate(player_key, row, col)
    |> reply()
  end

  defp reply({:ok, game}), do: {:reply, :ok, game}
  defp reply({:ok, game, ret_value}), do: {:reply, ret_value, game}
  defp reply({:error, game}), do: {:reply, :error, game}
  defp reply({:error, game, reason}), do: {:reply, {:error, reason}, game}
end
