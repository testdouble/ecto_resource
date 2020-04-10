use Mix.Config

config :ecto_resource, ecto_repos: [EctoResource.TestRepo]

import_config "#{Mix.env()}.exs"
