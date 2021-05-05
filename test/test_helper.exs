Supervisor.start_link([{EctoResource.TestRepo, []}],
  strategy: :one_for_one,
  name: EctoResource.Supervisor
)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(EctoResource.TestRepo, :manual)
