defmodule EctoResourceReadWriteTest do
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
        resource(MySchema, :read_write)
      end
    end

    test "generates __resource__(:resources)/0 for introspection" do
      assert FakeContext.__resource__(:resources) == [
               {Repo, MySchema,
                [
                  "all_my_schemas/1",
                  "change_my_schema/1",
                  "create_my_schema/1",
                  "create_my_schema!/1",
                  "get_my_schema/2",
                  "get_my_schema!/2",
                  "get_my_schema_by/2",
                  "get_my_schema_by!/2",
                  "update_my_schema/2",
                  "update_my_schema!/2"
                ]}
             ]
    end

    test "generates a get/2 function for the defined resources" do
      Repo
      |> expect(:get, fn _query, 123, [] -> %MySchema{id: 123} end)

      assert %MySchema{id: 123} = FakeContext.get_my_schema(123)
    end

    test "generates a get!/2 function for the defined resources" do
      Repo
      |> expect(:get!, fn _query, 123, [] -> %MySchema{id: 123} end)

      assert %MySchema{id: 123} = FakeContext.get_my_schema!(123)
    end

    test "generates an all/1 function for the defined resources" do
      Repo
      |> expect(:all, fn _query, [] -> [%MySchema{id: 123}] end)

      assert [%MySchema{id: 123}] = FakeContext.all_my_schemas()
    end

    test "generates a get_by/2 function for the defined resources" do
      Repo
      |> expect(:get_by, fn _schema, _attributes, _opts -> %MySchema{id: 123} end)

      assert %MySchema{id: 123} = FakeContext.get_my_schema_by(id: 123)
    end

    test "generates a get_by!/2 function for the defined resources" do
      Repo
      |> expect(:get_by!, fn _schema, _attributes, _opts -> %MySchema{id: 123} end)

      assert %MySchema{id: 123} = FakeContext.get_my_schema_by!(id: 123)
    end

    test "generates a change/1 function for the defined resources" do
      assert %Ecto.Changeset{data: %MySchema{}} = FakeContext.change_my_schema(%MySchema{id: 123})
    end

    test "generates a create/1 function for the defined resources" do
      Repo
      |> expect(:insert, fn _query, [] -> {:ok, %MySchema{id: 123}} end)

      assert {:ok, %MySchema{id: 123}} =
               FakeContext.create_my_schema(%{something_interesting: "You can totally do this"})
    end

    test "generates a create!/1 function for the defined resources" do
      Repo
      |> expect(:insert!, fn _query, [] -> {:ok, %MySchema{id: 123}} end)

      assert {:ok, %MySchema{id: 123}} =
               FakeContext.create_my_schema!(%{something_interesting: "You can totally do this"})
    end

    test "generates a update/2 function for the defined resources" do
      Repo
      |> expect(:update, fn _query, [] -> {:ok, %MySchema{id: 123}} end)

      assert {:ok, %MySchema{id: 123}} =
               FakeContext.update_my_schema(%MySchema{}, %{
                 someting_interesting: "Take the risk or lose the chance"
               })
    end

    test "generates a update!/2 function for the defined resources" do
      Repo
      |> expect(:update!, fn _query, [] -> {:ok, %MySchema{id: 123}} end)

      assert {:ok, %MySchema{id: 123}} =
               FakeContext.update_my_schema!(%MySchema{}, %{
                 someting_interesting: "Take the risk or lose the chance"
               })
    end
  end
end
