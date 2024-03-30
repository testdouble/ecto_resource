defmodule EctoCooler.DefaultsTestContext.People do
  @moduledoc false

  alias EctoCooler.TestRepo
  alias EctoCooler.TestSchema.Person

  use EctoCooler

  using_repo TestRepo do
    resource(Person)
  end
end

defmodule EctoCooler.DefaultsTest do
  use EctoCooler.RepoCase

  alias EctoCooler.TestSchema.Person
  alias EctoCooler.DefaultsTestContext.People

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
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      result = People.all()
      [first_person] = result

      assert length(result) == 1
      assert first_person.first_name == person.first_name
    end

    test "it filters by where" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      {:ok, _} =
        Person
        |> struct(%{first_name: "Other Test", last_name: "Other Person", age: 30})
        |> Repo.insert()

      result = People.all(where: [age: 42])
      [first_person] = result

      assert length(result) == 1
      assert first_person.first_name == person.first_name
    end
  end

  describe "change" do
    test "it returns a changeset with changes" do
      person = %Person{
        first_name: "Initial",
        last_name: "Value",
        age: 0
      }

      %{changes: changes} = People.change(person, @person_attributes)

      assert changes == @person_attributes
    end

    test "it accpets keyword lists" do
      person = %Person{
        first_name: "Initial",
        last_name: "Value",
        age: 0
      }

      person_attributes_list = Map.to_list(@person_attributes)

      %{changes: changes} = People.change(person, person_attributes_list)

      assert changes == @person_attributes
    end
  end

  describe "changeset" do
    test "it returns an empty changeset" do
      expected_changeset = Person.changeset(%Person{}, %{})
      assert People.changeset() == expected_changeset
    end
  end

  describe "create" do
    test "with valid attributbes, it creates a new record" do
      {:ok, person} = People.create(@person_attributes)

      assert Repo.all(Person) == [person]
    end

    test "with invalid attributes, it returns an error tuple with a changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create(%{})
    end

    test "accepts keyword lists" do
      person_attributes_list = Map.to_list(@person_attributes)
      {:ok, person} = People.create(person_attributes_list)

      assert Repo.all(Person) == [person]
    end
  end

  describe "create!" do
    test "with valid attributes, it creates a new record" do
      person = People.create!(@person_attributes)

      assert Repo.all(Person) == [person]
    end

    test "with invalid attributes, it raises an error" do
      assert_raise Ecto.InvalidChangesetError, fn ->
        People.create!(%{})
      end
    end

    test "it accepts keyword lists" do
      person_attributes_list = Map.to_list(@person_attributes)
      person = People.create!(person_attributes_list)

      assert Repo.all(Person) == [person]
    end
  end

  describe "delete" do
    test "with an existing record, it deletes a given record" do
      {:ok, person} =
        %Person{}
        |> Person.changeset(@person_attributes)
        |> Repo.insert()

      assert Repo.all(Person) == [person]

      People.delete(person)

      assert Repo.all(Person) == []
    end

    test "with a non-existent record, it raises an error" do
      {:ok, person} =
        %Person{}
        |> Person.changeset(@person_attributes)
        |> Repo.insert()

      Repo.delete(person)

      assert_raise Ecto.StaleEntryError, fn ->
        People.delete(person)
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

      People.delete!(person)

      assert Repo.all(Person) == []
    end

    test "with a non-existent record, it raises an error" do
      {:ok, person} =
        %Person{}
        |> Person.changeset(@person_attributes)
        |> Repo.insert()

      Repo.delete(person)

      assert_raise Ecto.StaleEntryError, fn ->
        People.delete!(person)
      end
    end
  end

  describe "get" do
    test "with an existing record, it returns the schema" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert person == People.get(person.id)
    end

    test "with a non-existent record, it returns nil" do
      assert nil == People.get(999)
    end
  end

  describe "get!" do
    test "with an existing record, it returns the schema" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert person == People.get!(person.id)
    end

    test "with a non-existent record, it raises an error" do
      assert_raise Ecto.NoResultsError, fn ->
        People.get!(999)
      end
    end
  end

  describe "get_by" do
    test "with an existing record, it returns a single schema matching the criteria" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert People.get_by(age: @person_attributes.age) == person
    end

    test "with a non-existent record, it returns nil" do
      assert People.get_by(age: @person_attributes.age) == nil
    end

    test "it accepts maps" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert People.get_by(%{age: @person_attributes.age}) == person
    end
  end

  describe "get_by!" do
    test "with an existing record, it returns a single schema, matching the criteria" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert People.get_by!(age: @person_attributes.age) == person
    end

    test "it accepts maps" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      assert People.get_by!(%{age: @person_attributes.age}) == person
    end
  end

  describe "update" do
    test "with valid attributes, it updates the values" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      {:ok, updated_person} = People.update(person, @updated_person_attributes)

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
               People.update(person, %{first_name: nil, last_name: nil, age: nil})

      refute changeset.valid?
    end

    test "accepts keyword lists" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      {:ok, updated_person} = People.update(person, Map.to_list(@updated_person_attributes))

      assert person.id == updated_person.id
      assert person.first_name != updated_person.first_name
      assert person.last_name != updated_person.last_name
      assert person.age != updated_person.age
    end
  end

  describe "update!" do
    test "with valid attributes, it updates the values" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      updated_person = People.update!(person, @updated_person_attributes)

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
        People.update!(person, %{first_name: nil, last_name: nil, age: nil})
      end
    end

    test "accepts keyword lists" do
      {:ok, person} =
        Person
        |> struct(@person_attributes)
        |> Repo.insert()

      updated_person = People.update!(person, Map.to_list(@updated_person_attributes))

      assert person.id == updated_person.id
      assert person.first_name != updated_person.first_name
      assert person.last_name != updated_person.last_name
      assert person.age != updated_person.age
    end
  end
end
