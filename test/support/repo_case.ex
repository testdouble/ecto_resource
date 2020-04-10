defmodule EctoResource.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias EctoResource.TestRepo, as: Repo
      import Ecto
      import Ecto.Query
      import EctoResource.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(EctoResource.TestRepo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(EctoResource.TestRepo, {:shared, self()})
    end

    :ok
  end
end
