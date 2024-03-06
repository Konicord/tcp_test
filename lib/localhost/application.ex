defmodule Localhost.Application do
  # https://hexdocs.pm/elixir/Application.html
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    port = String.to_integer(System.get_env("PORT") || "9000")
    children = [
      {Task.Supervisor, name: Localhost.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> Localhost.TCP.accept(port) end}, restart: :permanent, id: :tcp_accept),
      Supervisor.child_spec({Task, fn -> Localhost.Util.log() end}, id: :tcp_info)
    ]

    # https://hexdocs.pm/elixir/Supervisor.html
    opts = [strategy: :one_for_one, name: Localhost.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
