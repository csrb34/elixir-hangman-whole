defmodule Procs do
  def hello() do
    receive do
    msg ->
      IO.puts("Hello #{inspect(msg)}")
    end
    hello() # for recursion
  end

  def hello(what_to_say) do
    receive do
    msg ->
      IO.puts "#{what_to_say}: #{msg}"
    end
    hello(what_to_say) # for recursion
  end
end
