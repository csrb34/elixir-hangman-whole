defmodule Dictionary.Impl.WordListTest do
  use ExUnit.Case
	doctest Dictionary.Impl.WordList
	alias Dictionary.Impl.WordList

  test "new word list should load words" do
    word_list = WordList.word_list()

    assert length(word_list) > 0
    assert word_list != []
  end

  test "shoud return a random word from a list" do
    # random_word = WordList.random_word(WordList.start())
    random_word = WordList.word_list |> WordList.random_word

    refute String.trim(random_word) == ""
  end

end
