defmodule EctoResource.TestRepo do
  use Ecto.Repo,
    otp_app: :ecto_resource,
    adapter: Ecto.Adapters.Postgres
end
