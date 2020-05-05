defmodule EctoResource.ReadWriteContext.People do
  @moduledoc false

  alias EctoResource.TestRepo
  alias EctoResource.TestSchema.Person

  use EctoResource

  using_repo TestRepo do
    resource(Person, :read_write)
  end
end

defmodule EctoResource.ReadWrite do
  use EctoResource.RepoCase

  alias EctoResource.TestSchema.Person
  alias EctoResource.ReadWriteContext.People

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
    test "it returns an empty changeset" do
      expected_changeset = Person.changeset(%Person{}, %{})
      assert People.person_changeset() == expected_changeset
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
    test "it doesn't create a delete method" do
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
    test "doesn't create a delete! method" do
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
