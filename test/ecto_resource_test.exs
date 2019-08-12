defmodule EctoResourceTest do
  use ExUnit.Case
  doctest EctoResource
  alias MockRepo
  import Mox

  defmodule FakeData do
    use Ecto.Schema
    import Ecto.Changeset

    schema "fake_datas" do
      field(:something_interesting, :string)
    end

    def changeset(fake_data, attrs) do
      fake_data
      |> cast(attrs, [:something_interesting])
    end
  end

  describe "crud resource" do
    defmodule FakeContext do
      use EctoResource

      using_repo(MockRepo) do
        resource(FakeData)
      end
    end

    test "generates __resource__(:resources)/0 for introspection" do
      assert [
               {MockRepo, FakeData,
                [
                  "change_fake_data/1",
                  "create_fake_data/1",
                  "delete_fake_data/1",
                  "get_fake_data/2",
                  "all_fake_data/1",
                  "paginate_fake_data/2",
                  "update_fake_data/2"
                ]}
             ] = FakeContext.__resource__(:resources)
    end

    test "generates a change/1 function for the defined resources" do
      assert %Ecto.Changeset{data: %FakeData{}} = FakeContext.change_fake_data(%FakeData{id: 123})
    end

    test "generates a create/1 function for the defined resources" do
      MockRepo
      |> expect(:insert, fn _query, [] -> {:ok, %FakeData{id: 123}} end)

      assert {:ok, %FakeData{id: 123}} =
               FakeContext.create_fake_data(%{something_interesting: "You can totally do this"})
    end

    test "generates a delete/1 function for the defined resources" do
      MockRepo
      |> expect(:delete, fn _schema, [] -> {:ok, %FakeData{id: 123}} end)

      assert {:ok, %FakeData{id: 123}} = FakeContext.delete_fake_data(%FakeData{id: 123})
    end

    test "generates a get/2 function for the defined resources" do
      MockRepo
      |> expect(:get, fn _query, 123, [] -> %FakeData{id: 123} end)

      assert %FakeData{id: 123} = FakeContext.get_fake_data(123)
    end

    test "generates an all/1 function for the defined resources" do
      MockRepo
      |> expect(:all, fn _query, [] -> [%FakeData{id: 123}] end)

      assert [%FakeData{id: 123}] = FakeContext.all_fake_data()
    end

    test "generates a update/2 function for the defined resources" do
      MockRepo
      |> expect(:update, fn _query, [] -> {:ok, %FakeData{id: 123}} end)

      assert {:ok, %FakeData{id: 123}} =
               FakeContext.update_fake_data(%FakeData{}, %{
                 someting_interesting: "Take the risk or lose the chance"
               })
    end
  end
end
