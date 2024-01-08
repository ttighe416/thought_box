defmodule ThoughtBox.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ThoughtBoxWeb.Telemetry,
      # Start the Ecto repository
      ThoughtBox.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ThoughtBox.PubSub},
      # Start Finch
      {Finch, name: ThoughtBox.Finch},
      # Start the Endpoint (http/https)
      ThoughtBoxWeb.Endpoint
      # Start a worker by calling: ThoughtBox.Worker.start_link(arg)
      # {ThoughtBox.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ThoughtBox.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ThoughtBoxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
