defmodule TextClient.Impl.Player do

  @typep game :: Hangman.game
  @typep tally :: Hangman.tally
  @typep state :: { game, tally }

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    IO.puts game.letters |> to_string()
    IO.puts tally.letters |> to_string()
    interact({ game, tally })
  end

  @spec interact(state) :: :ok

  def interact({ _game, _tally = %{ game_state: :won }}) do
    IO.puts "Congratulations. You won!"
  end

  def interact({ game, _tally = %{ game_state: :lost }}) do
    IO.puts "Sorry, you lost... the word was #{game.letters |> Enum.join}"
  end

  def interact({game, tally}) do
    # feedback
    # display current word
    # get next guess
    # make move
    IO.puts feedback_for(tally)
    IO.puts current_word(tally)
    guess = get_guess()
    IO.puts guess
    {update_game, update_tally} = Hangman.make_move(game, guess)
    interact({ update_game, update_tally })
  end

  # @type   state :: :initializing | :good_guess | :bad_guess | :already_used | :invalid_char

  def feedback_for(tally = %{ game_state: :initializing }) do
    "Welcome! I'm thinking of a #{tally.letters |> length} letter word"
  end

  def feedback_for(_tally = %{ game_state: :good_guess }), do: "Good guess!"
  def feedback_for(_tally = %{ game_state: :bad_guess }), do: "Sorry, that letter's not in the word"
  def feedback_for(_tally = %{ game_state: :already_used }), do: "You already used that letter"
  def feedback_for(_tally = %{ game_state: :invalid_char }), do: "Sorry, that letter is invalid no accent written or especial charecters are allowed"

  def current_word(tally) do
    [
        "Word so far: ", tally.letters |> Enum.join(" "),
      "   turns left: ", tally.turns_left |> to_string,
      "   used so far: ", tally.used |> Enum.join(",")
    ]
  end

  def get_guess() do
    IO.gets("Next letter: ")
    |> String.trim()
    |> String.downcase()



  end
end
