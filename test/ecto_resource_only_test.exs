defmodule EctoResourceOnlyTest do
  use ExUnit.Case
  import Mox
  alias MockRepo, as: Repo

  defmodule MySchema do
    use Ecto.Schema
    import Ecto.Changeset

    schema "my_schemas" do
      field(:something_interesting, :string)
    end

    def changeset(my_schema, attrs) do
      my_schema
      |> cast(attrs, [:something_interesting])
    end
  end

  describe "crud resource" do
    defmodule FakeContext do
      use EctoResource

      using_repo(Repo) do
        resource(MySchema, only: [:create])
      end
    end

    test "generates __resource__(:resources)/0 for introspection" do
      assert FakeContext.__resource__(:resources) == [{Repo, MySchema, ["create_my_schema/1"]}]
    end

    test "generates a create/1 function for the defined resources" do
      Repo
      |> expect(:insert, fn _query, [] -> {:ok, %MySchema{id: 123}} end)

      assert {:ok, %MySchema{id: 123}} =
               FakeContext.create_my_schema(%{something_interesting: "You can totally do this"})
    end
  end
end
