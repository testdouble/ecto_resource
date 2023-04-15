defmodule EctoCooler.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias EctoCooler.TestRepo, as: Repo
      import Ecto
      import Ecto.Query
      import EctoCooler.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(EctoCooler.TestRepo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(EctoCooler.TestRepo, {:shared, self()})
    end

    :ok
  end
end
