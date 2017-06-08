to_process = [ 37, 37, 37, 37, 37 ]
nodes = [Node.self]

Enum.each 1..10, fn num_processes ->
  process_nodes =
    Enum.map(nodes, fn node ->
      {node, num_processes}
    end)

  {time, result} = :timer.tc(Scheduler, :run, [process_nodes, FibSolver, :fib, to_process])

  if num_processes == 1 do
    IO.puts inspect result
    IO.puts "\n # time (s)"
  end

  :io.format "~2B    ~.2f~n", [num_processes, time/1000000.0]
end
