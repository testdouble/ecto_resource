defmodule EctoResource.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_resource,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:mox, "~> 0.5.0", only: :test},
      {:postgrex, ">= 0.0.0"}
    ]
  end
end
