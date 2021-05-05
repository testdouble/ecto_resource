defmodule EctoResource.OnlyFilterTestContext.People do
  @moduledoc false

  alias EctoResource.TestRepo
  alias EctoResource.TestSchema.Person

  use EctoResource

  using_repo TestRepo do
    resource(Person, only: [:all, :change])
  end
end

defmodule EctoResource.OnlyFilterTest do
  use EctoResource.RepoCase

  alias EctoResource.TestSchema.Person
  alias EctoResource.OnlyFilterTestContext.People

  @person_attributes %{
    first_name: "Test",
    last_name: "Person",
    age: 42
  }

  @updated_person_attributes %{
    first_name: "Updated Test",
    last_name: "Updated Person",
    age: 33
  }

  describe "all" do
    test "it returns all the records" do
      person = struct(Person, @person_attributes)

      Repo.insert(person)
      [first_person] = results = People.all_people()

      assert length(results) == 1
      assert person.first_name == first_person.first_name
    end
  end

  describe "change" do
    test "it returns a changeset with changes" do
      person = %Person{
        first_name: "Initial",
        last_name: "Value",
        age: 0
      }

      %{changes: changes} = People.change_person(person, @person_attributes)

      assert changes == @person_attributes
    end
  end

  describe "changeset" do
    test "it doesn't create a changeset function" do
      assert_raise UndefinedFunctionError, fn ->
        People.person_changeset()
      end
    end
  end

  describe "create" do
    test "it doesn't create a create function" do
      assert_raise UndefinedFunctionError, fn ->
        People.create_person(@person_attributes)
      end
    end
  end

  describe "create!" do
    test "it doesn't create a create! function" do
      assert_raise UndefinedFunctionError, fn ->
        People.create_person!(@person_attributes)
      end
    end
  end

  describe "delete" do
    test "doesn't create a delete function" do
      {:ok, person} =
        %Person{}
        |> Person.changeset(@person_attributes)
        |> Repo.insert()

      assert_raise UndefinedFunctionError, fn ->
        People.delete_person(person)
      end
    end
  end

  describe "delete!" do
    test "doesn't create a delete! function" do
      {:ok, person} =
        %Person{}
        |> Person.changeset(@person_attributes)
        |> Repo.insert()

      assert_raise UndefinedFunctionError, fn ->
        People.delete_person!(person)
      end
    end
  end

  describe "get" do
    test "it doesn't create a get function" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert_raise UndefinedFunctionError, fn ->
        People.get_person(person.id)
      end
    end
  end

  describe "get!" do
    test "it doesn't create a get! function" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert_raise UndefinedFunctionError, fn ->
        People.get_person!(person.id)
      end
    end
  end

  describe "get_by" do
    test "doesn't create a get_by function" do
      assert_raise UndefinedFunctionError, fn ->
        People.get_person_by(age: @person_attributes.age)
      end
    end
  end

  describe "get_by!" do
    test "doesn't create a get_by! function" do
      assert_raise UndefinedFunctionError, fn ->
        People.get_person_by!(age: @person_attributes.age)
      end
    end
  end

  describe "update" do
    test "doesn't create an update function" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert_raise UndefinedFunctionError, fn ->
        People.update_person(person, @updated_person_attributes)
      end
    end
  end

  describe "update!" do
    test "doesn't create an update! function" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert_raise UndefinedFunctionError, fn ->
        People.update_person!(person, @updated_person_attributes)
      end
    end
  end
end
