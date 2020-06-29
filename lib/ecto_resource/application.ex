defmodule EctoResource.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    if Mix.env() != :prod do
      children = get_children(Mix.env())
      opts = [strategy: :one_for_one, name: EctoResource.Supervisor]
      Supervisor.start_link(children, opts)
    end
  end

  defp get_children(:test), do: [EctoResource.TestRepo]
  defp get_children(_), do: []
end
