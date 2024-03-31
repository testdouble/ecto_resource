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

config :ecto_cooler,
  app_name: "EctoCooler",
  schema_namespace: "Schema",
  repo_namespace: "Repo",
  repo_dir: "lib/ecto_cooler/repo",
  schema_dir: "lib/ecto_cooler/schema",
  app_slug: :ecto_cooler,
  migration_dir: "priv/repo/migrations",
  generators: [timestamp_type: :utc_datetime, binary_id: false]
