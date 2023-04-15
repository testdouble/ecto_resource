Supervisor.start_link([{EctoCooler.TestRepo, []}],
  strategy: :one_for_one,
  name: EctoCooler.Supervisor
)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(EctoCooler.TestRepo, :manual)
