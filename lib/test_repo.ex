defmodule EctoCooler.TestRepo do
  use Ecto.Repo,
    otp_app: :ecto_cooler,
    adapter: Ecto.Adapters.Postgres
end
