defmodule IslandsEngine.GameSupervisor do
  use Supervisor

  alias IslandsEngine.Game

  def start_link(_options) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    # Will trigger init(:ok)
  end

  def init(:ok) do
    Supervisor.init([Game], strategy: :simple_one_for_one)
  end

  def start_game(name) do
    # See. Page 114 - on confusing explanation on how it works
    Supervisor.start_child(__MODULE__, [name])
  end

  def stop_game(name) do
    Supervisor.terminate_child(__MODULE__, pid_from_name(name))
  end

  defp pid_from_name(name) do
    name
    |> Game.via_tuple()
    |> GenServer.whereis()
  end
end