defmodule Dictionary do
  @moduledoc false

  alias Dictionary.Impl.WordList

  @opaque t :: WordList.t

  @spec start :: t
  defdelegate start, to: WordList, as: :word_list

  @spec random_word(t) :: String.t
  defdelegate random_word(word_list), to: WordList
end
