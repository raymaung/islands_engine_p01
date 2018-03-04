defmodule IslandsEngine.Board do
  alias IslandsEngine.Island
  alias IslandsEngine.Coordinate

  def new() do
    %{}
  end

  def position_island(board, key, %Island{} = island) do
    case overlaps_existing_island?(board, key, island) do
      true -> {:error, :overlapping_island}
      false -> Map.put(board, key, island)
    end
  end

  defp overlaps_existing_island?(board, new_key, new_island) do
    Enum.any?(board, fn {key, island} ->
      key != new_key and Island.overlaps?(island, new_island)
    end)
  end

  def all_islands_positioned?(board) do
    Enum.all?(Island.types(), &(Map.has_key?(board, &1)))
  end

  def guess(board, %Coordinate{} = coordinate) do
    board
    |> check_all_islands(coordinate)
    |> guess_response(board)
  end

  defp check_all_islands(board, coordinate) do
    Enum.find_value(board, :miss, fn {key, island} ->
      case Island.guess(island, coordinate) do
        {:hit, island} -> {key, island}
        :miss -> false
      end
    end)
  end

  defp guess_response({key, island}, board) do
    board = %{board | key => island}
    {:hit, forest_check(board, key), win_check(board), board}
  end
  defp guess_response(:miss, board), do: {:miss, :none, :no_win, board}

  defp forest_check(board, key) do
    case forested?(board, key) do
      true -> key
      false -> :none
    end
  end

  defp forested?(board, key) do
    board
    |> Map.fetch!(key)
    |> Island.forested?()
  end

  defp win_check(board) do
    case all_forested?(board) do
      true -> :win
      false -> :no_win
    end
  end

  defp all_forested?(board) do
    Enum.all?(board, fn {_key, island} -> Island.forested?(island)
    end)
  end
end

#
# Testing Out
#

# alias IslandsEngine.{Board, Coordinate, Island}

# board = Board.new()
# {:ok, square_coordinate} = Coordinate.new(1, 1)

# {:ok, square} = Island.new(:square, square_coordinate)
# board = Board.position_island(board, :square, square)

# {:ok, dot_coordinate} = Coordinate.new(2, 2)
# {:ok, dot} = Island.new(:dot, dot_coordinate)
# Board.position_island(board, :dot, dot)

# {:ok, new_dot_coordinate} = Coordinate.new(3, 3)
# {:ok, dot} = Island.new(:dot, new_dot_coordinate)
# board = Board.position_island(board, :dot, dot)

# {:ok, guess_coordinate} = Coordinate.new(10, 10)
# {:miss, :none, :no_win, board} = Board.guess(board, guess_coordinate)

# {:ok, hit_coordinate} = Coordinate.new(1, 1)
# {:hit, :none, :no_win, board} = Board.guess(board, hit_coordinate)

# square = %{square | hit_coordinates: square.coordinates}
# board = Board.position_island(board, :square, square)

# {:ok, win_coordinate} = Coordinate.new(3, 3)
# {:hit, :dot, :win, board} = Board.guess(board, win_coordinate)
