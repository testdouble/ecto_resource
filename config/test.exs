import Config

config :ecto_cooler, ecto_repos: [EctoCooler.TestRepo]

config :ecto_cooler, EctoCooler.TestRepo,
  username: "postgres",
  password: "postgres",
  database: "ecto_cooler_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Print only warnings and errors during test
config :logger, level: :warn
