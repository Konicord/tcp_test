defmodule Localhost.TCP do
  require Logger

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false])
    Logger.info("Connections online on port #{port}")
    loop(socket)
  end

  defp loop(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(Localhost.TaskSupervisor, fn -> serve(client) end)

    :ok = :gen_tcp.controlling_process(client, pid)
    loop(socket)
  end

  defp serve(socket) do
    socket |> read_line() |> write_line(socket)
    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(_, socket) do
    :gen_tcp.send(socket, "HTTP/1.0 200 OK\r\n\r\nHello, User!\r\n")
  end
end
