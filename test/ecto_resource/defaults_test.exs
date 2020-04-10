defmodule EctoResource.TestContext.People do
  @moduledoc false

  alias EctoResource.TestRepo
  alias EctoResource.TestSchema.Person

  use EctoResource

  using_repo TestRepo do
    resource(Person)
  end
end

defmodule EctoResource.DefaultsTest do
  use ExUnit.Case

  alias EctoResource.TestRepo, as: Repo
  alias EctoResource.TestSchema.Person
  alias EctoResource.TestContext.People

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "changeset" do
    test "it returns an empty changeset" do
      expected_changeset = Person.changeset(%Person{}, %{})
      assert People.changeset() == expected_changeset
    end
  end

  describe "change" do
    test "it returns a changeset with changes" do
      person = %Person{
        first_name: "Initial",
        last_name: "Value",
        age: 0
      }

      expected_changes = %{
        first_name: "Test",
        last_name: "Person",
        age: 42
      }

      %{changes: changes} = People.change_person(person, expected_changes)

      assert changes == expected_changes
    end
  end

  # describe "all" do
  #   test "it returns all the records" do
  #     TestRepo.insert(%Person{
  #       first_name: "Test",
  #       last_name: "Person",
  #       age: 42
  #     })

  #     assert [%Person{}] = People.all()
  #   end
  # end
end
