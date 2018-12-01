defmodule Project1 do

    use GenServer

    def main(args) do

       n=String.to_integer(hd(args))
       k=String.to_integer(List.last(args))

       Enum.each(1..n, fn(num)->
         {:ok,pid} = Project1.start_link               #spawns n processes from 1 to n
         Project1.perform_calcs(pid,num,k)
       end)

    end

    def start_link do
      GenServer.start_link(__MODULE__,[])
    end

    def init([]) do
      {:ok, []}
    end

    def perform_calcs(process_id, n1, k1) do
      GenServer.cast(process_id, {:async_sum, n1, k1})              #Handle cast call for processing sum and root
    end

    def handle_cast({:async_sum, n, k}, state) do

      last=n+k-1
      var_sqrt=Enum.map(n..last, fn x-> x*x end)|>Enum.sum|>:math.sqrt      #gives the square root of the sum of sequence
      var_floor=Float.floor(var_sqrt)

      if ((var_sqrt - var_floor) == 0),do:                                  #checks for perfect square
        IO.puts("#{n}")
        {:stop, :normal, state}

    end

end
