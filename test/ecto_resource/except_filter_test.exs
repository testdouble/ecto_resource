defmodule EctoResource.ExceptFilterTestContext.People do
  @moduledoc false

  alias EctoResource.TestRepo
  alias EctoResource.TestSchema.Person

  use EctoResource

  using_repo TestRepo do
    resource(Person, except: [:change, :changeset])
  end
end

defmodule EctoResource.ExceptFilterTest do
  use EctoResource.RepoCase

  alias EctoResource.TestSchema.Person
  alias EctoResource.ExceptFilterTestContext.People

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
    test "doesn't create a change function" do
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
    test "with valid attributbes, it creates a new record" do
      {:ok, person} = People.create_person(@person_attributes)

      assert Repo.all(Person) == [person]
    end

    test "with invalid attributes, it returns an error tuple with a changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_person(%{})
    end
  end

  describe "create!" do
    test "whith valid attributes, it creates a new record" do
      person = People.create_person!(@person_attributes)

      assert Repo.all(Person) == [person]
    end

    test "with invalid attributes, it raises an error" do
      assert_raise Ecto.InvalidChangesetError, fn ->
        People.create_person!(%{})
      end
    end
  end

  describe "delete" do
    test "with an existing record, it deletes a given record" do
      {:ok, person} =
        %Person{}
        |> Person.changeset(@person_attributes)
        |> Repo.insert()

      assert Repo.all(Person) == [person]

      People.delete_person(person)

      assert Repo.all(Person) == []
    end

    test "with a non-existent record, it raises an error" do
      {:ok, person} =
        %Person{}
        |> Person.changeset(@person_attributes)
        |> Repo.insert()

      Repo.delete(person)

      assert_raise Ecto.StaleEntryError, fn ->
        People.delete_person(person)
      end
    end
  end

  describe "delete!" do
    test "with an existing record it deletes the given record" do
      {:ok, person} =
        %Person{}
        |> Person.changeset(@person_attributes)
        |> Repo.insert()

      assert Repo.all(Person) == [person]

      People.delete_person!(person)

      assert Repo.all(Person) == []
    end

    test "with a non-existent record, it raises an error" do
      {:ok, person} =
        %Person{}
        |> Person.changeset(@person_attributes)
        |> Repo.insert()

      Repo.delete(person)

      assert_raise Ecto.StaleEntryError, fn ->
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
    test "with valid attributes, it updates the values" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      {:ok, updated_person} = People.update_person(person, @updated_person_attributes)

      assert person.id == updated_person.id
      assert person.first_name != updated_person.first_name
      assert person.last_name != updated_person.last_name
      assert person.age != updated_person.age
    end

    test "with invalid attributes, it returns an error changeset tuple" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert {:error, changeset} =
               People.update_person(person, %{first_name: nil, last_name: nil, age: nil})

      refute changeset.valid?
    end
  end

  describe "update!" do
    test "with valid attributes, it updates the values" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      updated_person = People.update_person!(person, @updated_person_attributes)

      assert person.id == updated_person.id
      assert person.first_name != updated_person.first_name
      assert person.last_name != updated_person.last_name
      assert person.age != updated_person.age
    end

    test "with invalid attributes, it returns an error changeset tuple" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert_raise Ecto.InvalidChangesetError, fn ->
        People.update_person!(person, %{first_name: nil, last_name: nil, age: nil})
      end
    end
  end
end
