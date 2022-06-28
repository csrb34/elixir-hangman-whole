defmodule Hangman.Impl.GameTest do
	use ExUnit.Case
	doctest Hangman.Impl.Game
	alias Hangman.Impl.Game

  test "new game returns structure" do
    game = Game.new_game

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new game returns correct word" do
    word = "wombat"
    game = Game.new_game(word)

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) == 6
    assert game.letters == ["w", "o", "m", "b", "a", "t"]
    assert game.letters == word |> String.codepoints
  end

end
