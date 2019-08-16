defmodule EctoResourceReadTest do
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

  describe "readable resource" do
    defmodule FakeContext do
      use EctoResource

      using_repo(Repo) do
        resource(MySchema, :read)
      end
    end

    test "generates __resource__(:resources)/0 for introspection" do
      assert FakeContext.__resource__(:resources) == [
               {Repo, MySchema,
                [
                  "all_my_schemas/1",
                  "get_my_schema/2"
                ]}
             ]
    end

    test "generates a get/2 function for the defined resources" do
      Repo
      |> expect(:get, fn _query, 123, [] -> %MySchema{id: 123} end)

      assert %MySchema{id: 123} = FakeContext.get_my_schema(123)
    end

    test "generates an all/1 function for the defined resources" do
      Repo
      |> expect(:all, fn _query, [] -> [%MySchema{id: 123}] end)

      assert [%MySchema{id: 123}] = FakeContext.all_my_schemas()
    end
  end
end
