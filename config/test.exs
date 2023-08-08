import Config

config :ecto_resource, ecto_repos: [EctoResource.TestRepo]

config :ecto_resource, EctoResource.TestRepo,
  username: "postgres",
  password: "postgres",
  database: "ecto_resource_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :info
