defmodule Dictionary.Impl.WordList do
  @moduledoc false

  @type t :: list(String.t)

  @spec word_list :: t
  def word_list do
    # dictionary/assets/words.txt
    # dictionary/lib/impl/word_list.ex
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
  end

  @spec random_word(t) :: String.t
  def random_word(word_list) do
    word_list
    |> Enum.random()
  end
end
