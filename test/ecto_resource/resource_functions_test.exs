defmodule EctoResource.ResourceFunctionsTestContext.People do
  use EctoResource

  alias EctoResource.TestRepo
  alias EctoResource.TestSchema.Person

  using_repo TestRepo do
    resource(Person)
  end
end

defmodule EctoResource.ResourceFunctionsTest do
  use EctoResource.RepoCase

  alias EctoResource.TestSchema.Person
  alias EctoResource.ResourceFunctionsTestContext.People

  defp create_person(opts) do
    opts = Keyword.merge([first_name: "Test", last_name: "Person", age: 42], opts)

    Person |> struct(opts) |> Repo.insert!()
  end

  describe "all/2" do
    setup do
      michael = create_person(first_name: "Michael", age: 50)
      dwight = create_person(first_name: "Dwight", age: 33)

      %{michael: michael, dwight: dwight}
    end

    test "returns all records", %{
      michael: michael,
      dwight: dwight
    } do
      people = People.all_people()

      assert michael in people
      assert dwight in people
    end

    test "returns all records with a where clause", %{
      michael: michael,
      dwight: dwight
    } do
      assert People.all_people(where: [age: 50]) == [michael]
      assert People.all_people(where: [age: 33]) == [dwight]
    end

    test "returns all records up to limit", %{
      michael: michael,
      dwight: dwight
    } do
      assert People.all_people(limit: 1) == [michael]
      assert People.all_people(limit: 2) == [michael, dwight]
    end

    test "returns records in order of order_by", %{
      michael: michael,
      dwight: dwight
    } do
      assert People.all_people(order_by: :age) == [dwight, michael]
      assert People.all_people(order_by: [desc: :age]) == [michael, dwight]
    end

    test "returns records with offset", %{
      dwight: dwight
    } do
      assert People.all_people(offset: 1) == [dwight]
      assert People.all_people(offset: 2) == []
    end
  end
end
