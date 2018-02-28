defmodule IslandsEngine.RulesTest do
  use ExUnit.Case

  alias IslandsEngine.Rules

  test "verify player one's turn" do
    rules = Rules.new()
    rules = %Rules{rules | state: :player1_turn}

    assert rules.state == :player1_turn
    assert Rules.check(rules, {:guess_coordinate, :player2}) == :error

    {:ok, rules} = Rules.check(rules, {:guess_coordinate, :player1})
    assert rules.state == :player2_turn
  end

  test "verify player1 continues the turn on no_win " do
    rules = Rules.new()
    rules = %Rules{rules | state: :player1_turn}
    {:ok, rules} = Rules.check(rules, {:win_check, :no_win})
    assert rules.state == :player1_turn
  end

  test "verify the game is over when player1 wins" do
    rules = Rules.new()
    rules = %Rules{rules | state: :player1_turn}
    {:ok, rules} = Rules.check(rules, {:win_check, :win})
    assert rules.state == :game_over
  end

  test "verify game over" do
    rules = Rules.new()
    assert rules.state == :initialized

    {:ok, rules} = Rules.check(rules, :add_player)
    assert rules.state == :players_set

    {:ok, rules} = Rules.check(rules, {:position_islands, :player1})
    assert rules.state == :players_set

    {:ok, rules} = Rules.check(rules, {:position_islands, :player2})
    assert rules.state ==:players_set

    {:ok, rules} = Rules.check(rules, {:set_islands, :player1})
    assert rules.state ==:players_set

    {:ok, rules} = Rules.check(rules, {:position_islands, :player2})
    assert rules.state ==:players_set

    {:ok, rules} = Rules.check(rules, {:set_islands, :player2})
    assert rules.state ==:player1_turn
    assert Rules.check(rules, {:guess_coordinate, :player2}) == :error

    {:ok, rules} = Rules.check(rules, {:guess_coordinate, :player1})
    assert rules.state ==:player2_turn

    assert Rules.check(rules, {:guess_coordinate, :player1}) == :error

    {:ok, rules} = Rules.check(rules, {:guess_coordinate, :player2})
    assert rules.state ==:player1_turn

    {:ok, rules} = Rules.check(rules, {:win_check, :no_win})
    assert rules.state ==:player1_turn

    {:ok, rules} = Rules.check(rules, {:win_check, :win})
    assert rules.state ==:game_over
  end
end

