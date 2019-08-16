defmodule EctoResourceDeleteTest do
  use ExUnit.Case
  alias MockRepo, as: Repo
  import Mox

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

  describe "writeable resource" do
    defmodule FakeContext do
      use EctoResource

      using_repo(Repo) do
        resource(MySchema, :delete)
      end
    end

    test "generates __resource__(:resources)/0 for introspection" do
      assert FakeContext.__resource__(:resources) == [{Repo, MySchema, ["delete_my_schema/1"]}]
    end

    test "generates a delete/1 function for the defined resources" do
      Repo
      |> expect(:delete, fn _schema, [] -> {:ok, %MySchema{id: 123}} end)

      assert {:ok, %MySchema{id: 123}} = FakeContext.delete_my_schema(%MySchema{id: 123})
    end
  end
end
