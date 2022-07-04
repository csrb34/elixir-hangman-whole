defmodule Hangman do
  @moduledoc """
  Documentation for `Hangman`.
  """

  alias Hangman.Impl.Game #, as: Game # alias without 'as' use the last one in the chain of module names
  alias Hangman.Type

  @opaque game :: Game.t

  @spec new_game() :: game
  defdelegate new_game, to: Game

  @spec init_game() :: game
  defdelegate init_game, to: Game, as: :new_game

  @spec new_game_2() :: game
  defdelegate new_game_2, to: Game, as: :init_game

  @spec make_move(game, String.t) :: {game, Type.tally}
  def make_move(_game, _guess) do
  end
end
