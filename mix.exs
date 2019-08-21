defmodule EctoResource.MixProject do
  use Mix.Project

  def project do
    [
      aliases: aliases(),
      app: :ecto_resource,
      deps: deps(),
      description: description(),
      dialyzer: [plt_add_apps: [:mix]],
      docs: [
        main: "readme",
        extras: ["README.md"],
        api_reference: false
      ],
      elixir: "~> 1.8",
      package: package(),
      start_permanent: Mix.env() == :prod,
      version: "1.0.3"
    ]
  end

  defp aliases do
    [
      credo: "credo --strict --config-file .credo.ex",
      check: ["credo", "dialyzer", "inch"]
    ]
  end

  defp description do
    """
    A simple module to clear up the boilerplate of CRUD resources in Phoenix context files.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Dayton Nolan"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/daytonn/ecto_resource"}
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
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:inch_ex, github: "rrrene/inch_ex", only: [:dev, :test]},
      {:inflex, "~> 2.0.0"},
      {:mox, "~> 0.5.0", only: :test},
      {:postgrex, ">= 0.0.0"}
    ]
  end
end
