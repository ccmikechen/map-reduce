to_process = [ 37, 37, 37, 37, 37 ]

Node.connect(:"b508@192.168.1.23")
Node.connect(:"b207@192.168.1.24")
Node.connect(:"b309@192.168.1.25")

nodes = [Node.self | Node.list]

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
