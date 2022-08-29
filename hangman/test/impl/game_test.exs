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

  test "normalize and lowercase word characters" do
    word = "ReGálÓ"

    game = Game.new_game(word)
    assert game.letters |> Enum.join("") =~ ~r/^[a-z]+/u
  end

  test "make a move with a capital letter fails" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "R")
    assert tally.game_state == :invalid_char
  end

  test "make a move with a capital letter fails even when is in the word" do
    game = Game.new_game("Wombat")
    {_game, tally} = Game.make_move(game, "W")
    assert tally.game_state == :invalid_char
  end

  test "make a move with a written accent letter fails" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "á")
    assert tally.game_state == :invalid_char
  end

  test "make a move with a number fails" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "3")
    assert tally.game_state == :invalid_char
  end

  test "state doesn't change if a game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat")
      game = Map.put(game, :game_state, state)
      {new_game, _tally} = Game.make_move(game, 'x')
      assert new_game === game
    end
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state !== :already_used
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state !== :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "record letters used" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x","y"]))
  end

  test "we recognize a letter in the word" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "m")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "t")
    assert tally.game_state == :good_guess
  end

  test "we recognize a letter is not in the word" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "x")
    assert tally.game_state == :bad_guess
  end

  test "we won the game when guessing the last letter" do
    game = Game.new_game("wombat")
    {game, _tally} = Game.make_move(game, "w")
    {game, _tally} = Game.make_move(game, "o")
    {game, _tally} = Game.make_move(game, "m")
    {game, _tally} = Game.make_move(game, "b")
    {game, _tally} = Game.make_move(game, "a")
    {_game, tally} = Game.make_move(game, "t")
    assert tally.game_state == :won
  end

  # Game word: hello
  test "can handle a sequence of moves" do
    [
      # guess state           turns-left letters                used
      ["a",   :bad_guess,     6,         ["_","_","_","_","_"], ["a"]],
      ["a",   :already_used,  6,         ["_","_","_","_","_"], ["a"]],
      ["e",   :good_guess,    6,         ["_","e","_","_","_"], ["a", "e"]],
      ["x",   :bad_guess,     5,         ["_","e","_","_","_"], ["a", "e", "x"]],
    ]
    |> test_sequence_of_moves()

  end

  test "can handle a winning game" do
    [
      # guess state           turns-left letters                used
      ["a",   :bad_guess,     6,         ["_","_","_","_","_"], ["a"]],
      ["a",   :already_used,  6,         ["_","_","_","_","_"], ["a"]],
      ["e",   :good_guess,    6,         ["_","e","_","_","_"], ["a", "e"]],
      ["x",   :bad_guess,     5,         ["_","e","_","_","_"], ["a", "e", "x"]],
      ["l",   :good_guess,    5,         ["_","e","l","l","_"], ["a", "e", "l", "x"]],
      ["o",   :good_guess,    5,         ["_","e","l","l","o"], ["a", "e", "l", "o", "x"]],
      ["y",   :bad_guess,     4,         ["_","e","l","l","o"], ["a", "e", "l", "o", "x", "y"]],
      ["h",   :won,           4,         ["h","e","l","l","o"], ["a", "e", "h", "l", "o", "x", "y"]],
    ]
    |> test_sequence_of_moves()

  end

  test "can handle a failing game" do
    [
      # guess state         turns-left letters                used
      ["a",   :bad_guess,   6,         ["_","_","_","_","_"], ["a"]],
      ["b",   :bad_guess,   5,         ["_","_","_","_","_"], ["a", "b"]],
      ["c",   :bad_guess,   4,         ["_","_","_","_","_"], ["a", "b", "c",]],
      ["d",   :bad_guess,   3,         ["_","_","_","_","_"], ["a", "b", "c", "d"]],
      ["e",   :good_guess,  3,         ["_","e","_","_","_"], ["a", "b", "c", "d", "e"]],
      ["f",   :bad_guess,   2,         ["_","e","_","_","_"], ["a", "b", "c", "d", "e", "f"]],
      ["g",   :bad_guess,   1,         ["_","e","_","_","_"], ["a", "b", "c", "d", "e", "f", "g"]],
      ["h",   :good_guess,  1,         ["h","e","_","_","_"], ["a", "b", "c", "d", "e", "f", "g", "h"]],
      ["i",   :lost,        0,         ["h","e","l","l","o"], ["a", "b", "c", "d", "e", "f", "g", "h", "i"]],
    ]
    |> test_sequence_of_moves()

  end

  defp test_sequence_of_moves(script) do
    game = Game.new_game("hello")
    Enum.reduce(script, game, &check_one_move/2)
  end

  defp check_one_move([guess, state, turns_left, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)

    assert tally.game_state == state
    assert tally.turns_left == turns_left
    assert tally.letters == letters
    assert tally.used == used

    game # retur the modified game to next iteration in redice function
  end
end
