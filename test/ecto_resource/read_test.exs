defmodule EctoResource.ReadTestContext.People do
  @moduledoc false

  alias EctoResource.TestRepo
  alias EctoResource.TestSchema.Person

  use EctoResource

  using_repo TestRepo do
    resource(Person, :read)
  end
end

defmodule EctoResource.ReadTest do
  use EctoResource.RepoCase

  alias EctoResource.TestSchema.Person
  alias EctoResource.ReadTestContext.People

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

      assert [person] = People.all_people()
    end
  end

  describe "change" do
    test "it doesn't create a change function" do
      person = %Person{
        first_name: "Initial",
        last_name: "Value",
        age: 0
      }

      assert_raise UndefinedFunctionError, fn ->
        People.change_person(person, @person_attributes)
      end
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
    test "it doesn't create a delete function" do
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
    test "it doesn't create a delete! function" do
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
    test "with an existing record, it returns the schema" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert person == People.get_person(person.id)
    end

    test "with a non-existent record, it returns nil" do
      assert nil == People.get_person(999)
    end
  end

  describe "get!" do
    test "with an existing record, it returns the schema" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert person == People.get_person!(person.id)
    end

    test "with a non-existent record, it raises an error" do
      assert_raise Ecto.NoResultsError, fn ->
        People.get_person!(999)
      end
    end
  end

  describe "get_by" do
    test "with an existing record, it returns a single schema matching the criteria" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert People.get_person_by(age: @person_attributes.age) == person
    end

    test "with a non-existent record, it returns nil" do
      assert People.get_person_by(age: @person_attributes.age) == nil
    end
  end

  describe "get_by!" do
    test "with an existing record, it returns a single schema, matching the criteria" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert People.get_person_by!(age: @person_attributes.age) == person
    end
  end

  describe "update" do
    test "it doesn't create an update function" do
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
    test "it doesn't create an update function" do
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
