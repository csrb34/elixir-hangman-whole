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

  test "new game word letters are all lowercase a-z character" do
    word = "regalo"

    game = Game.new_game(word)
    assert game.letters |> Enum.join("") =~ ~r/^[a-z]+/u
  end

  test "fails because word letters are not all lowercase a-z character" do
    word = "ReGalO"

    game = Game.new_game(word)
    refute game.letters |> Enum.join("") =~ ~r/^[a-z]+/u
  end

end
