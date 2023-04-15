import Config

config :ecto_cooler, env: config_env()

import_config "#{config_env()}.exs"
