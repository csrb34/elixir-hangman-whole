defmodule TextClient do
  @moduledoc """
  Documentation for `TextClient`.
  """

@spec start() :: :ok
defdelegate start(), to: TextClient.Impl.Player

end
