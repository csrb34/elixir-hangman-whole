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
    {game, tally} = Game.make_move(game, "t")
    assert tally.game_state == :won
  end

  # hello
  test "can handle a sequence of moves" do
    [
      # guess state       turns-left letters                used
      ["a",   :bad_guess,  6,         ["_","_","_","_","_",], ["a"]],
      ["a",   :bad_guess,  6,         ["_","_","_","_","_",], ["a"]],
      ["e",   :good_guess, 6,         ["_","e","_","_","_",], ["a", "e"]],
      ["x",   :bad_guess,  5,         ["_","e","_","_","_",], ["a", "e", "x"]],
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
