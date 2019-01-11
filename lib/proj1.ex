defmodule Project1 do
  use GenServer

  def main(args) do
    n = String.to_integer(hd(args))
    k = String.to_integer(List.last(args))

    Enum.each(1..n, fn num ->
      # spawns n processes from 1 to n
      {:ok, pid} = Project1.start_link()
      Project1.perform_calcs(pid, num, k)
    end)
  end

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, []}
  end

  def perform_calcs(process_id, n1, k1) do
    # Handle cast call for processing sum and root
    GenServer.cast(process_id, {:async_sum, n1, k1})
  end

  def handle_cast({:async_sum, n, k}, state) do
    last = n + k - 1
    # gives the square root of the sum of sequence
    var_sqrt = Enum.map(n..last, fn x -> x * x end) |> Enum.sum() |> :math.sqrt()
    var_floor = Float.floor(var_sqrt)

    # checks for perfect square
    if var_sqrt - var_floor == 0, do: IO.puts("#{n}")
    {:stop, :normal, state}
  end
end
