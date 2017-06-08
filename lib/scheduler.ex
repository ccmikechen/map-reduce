defmodule Scheduler do

  def run(process_nodes, module, func, to_calculate) do
    process_nodes
    |> Enum.map(fn({node, num}) ->
      (1..num)
      |> Enum.map(fn(_) -> Node.spawn(node, module, func, [self]) end)
      |> schedule_processes(to_calculate, [])
    end)
  end

  defp schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [ next | tail ] = queue
        send pid, {:fib, next, self}
        schedule_processes(processes, tail, results)

      {:ready, pid} ->
        send pid, {:shutdown}
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, results)
        else
          Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
        end

      {:answer, number, result, _pid} ->
        schedule_processes(processes, queue, [ {number, result} | results])
    end
  end
end
