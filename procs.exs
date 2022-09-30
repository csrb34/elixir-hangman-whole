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

  def count_hello(count) do
    receive do
    msg ->
      IO.puts "#{count}: Hello #{msg}"
    end
    count_hello(count + 1) # for recursion
  end

  def count_hello_pm(count) do
    receive do
    {:quit} ->
      IO.puts "I'm outta here" # finish the process
    {:add, n} ->
      count_hello_pm(count + n)
    {:reset} ->
      count_hello_pm(0)
    :reset2 ->
      count_hello_pm(0)
    msg ->
      IO.puts "#{count}: Hello #{msg}"
      count_hello_pm(count)
    end
  end

  def hello2(count) do
    receive do
    {:crash, reason} ->
      exit(reason)
    {:quit} ->
      IO.puts "I'm outta here"
    {:add, n} ->
      hello2(count + n)
    {:reset} ->
      hello2(0)
    msg ->
      IO.puts "#{count}: Hello #{msg}"
      hello2(count)
    end
  end

end
