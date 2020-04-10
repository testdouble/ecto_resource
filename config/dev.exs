use Mix.Config

config :ecto_resource, EctoResource.TestRepo,
  database: "ecto_resource_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
