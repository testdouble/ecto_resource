defmodule EctoResourceExceptTest do
  use ExUnit.Case
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
        resource(MySchema, except: [:all, :create, :delete, :get, :update])
      end
    end

    test "generates __resource__(:resources)/0 for introspection" do
      assert FakeContext.__resource__(:resources) == [{Repo, MySchema, ["change_my_schema/1"]}]
    end

    test "generates a change/1 function for the defined resources" do
      assert %Ecto.Changeset{data: %MySchema{}} = FakeContext.change_my_schema(%MySchema{id: 123})
    end
  end
end
