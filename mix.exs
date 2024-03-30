defmodule EctoCooler.MixProject do
  use Mix.Project

  def project do
    [
      aliases: aliases(),
      app: :ecto_cooler,
      deps: deps(),
      description: description(),
      dialyzer: [plt_add_apps: [:mix]],
      docs: [
        main: "readme",
        extras: ["README.md"],
        api_reference: false
      ],
      elixir: ">= 1.14.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      start_permanent: Mix.env() == :prod,
      version: "1.0.0"
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
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
      links: %{"GitHub" => "https://github.com/daytonn/ecto_cooler"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger, :bunt, :eex]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bunt, "~> 1.0"},
      {:ecto_sql, ">= 3.10.1"},
      {:ex_doc, ">= 0.29.4", only: :dev, runtime: false},
      {:inflex, ">= 2.1.0"},
      {:postgrex, ">= 0.17.1", only: [:test]}
    ]
  end
end
