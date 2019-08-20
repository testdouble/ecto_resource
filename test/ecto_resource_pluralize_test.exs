defmodule EctoResourcePluralizeTest do
  use ExUnit.Case
  alias MockRepo, as: Repo

  defmodule Person do
    use Ecto.Schema
    import Ecto.Changeset

    schema "people" do
      field(:something_interesting, :string)
    end

    def changeset(my_person, attrs) do
      my_person
      |> cast(attrs, [:something_interesting])
    end
  end

  describe "crud resource" do
    defmodule FakeContext do
      use EctoResource

      using_repo(Repo) do
        resource(Person)
      end
    end

    test "generates __resource__(:resources)/0 for introspection" do
      assert FakeContext.__resource__(:resources) == [
               {Repo, Person,
                [
                  "all_people/1",
                  "change_person/1",
                  "create_person/1",
                  "create_person!/1",
                  "delete_person/1",
                  "delete_person!/1",
                  "get_person/2",
                  "get_person!/2",
                  "update_person/2",
                  "update_person!/2"
                ]}
             ]
    end
  end
end
