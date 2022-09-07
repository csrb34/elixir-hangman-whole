defmodule Procs do
  def hello(name) do
    Process.sleep(1000)
    IO.puts("Hello #{name}")
  end
end
