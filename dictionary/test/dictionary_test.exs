defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "new word list should load words" do
    word_list = Dictionary.start()

    assert length(word_list) > 0
    assert word_list != []
  end

  test "shoud return a random word from a list" do
    # random_word = WordList.random_word(WordList.start())
    random_word = Dictionary.start |> Dictionary.random_word

    refute String.trim(random_word) == ""
  end
end
