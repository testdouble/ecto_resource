defmodule EctoResourceNoSuffixTest do
  use ExUnit.Case
  alias MockRepo, as: Repo

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

  describe "readable resource" do
    defmodule FakeContext do
      use EctoResource

      using_repo(Repo) do
        resource(MySchema, suffix: false)
      end
    end

    test "generates __resource__(:resources)/0 for introspection" do
      assert FakeContext.__resource__(:resources) == [
               {Repo, MySchema,
                [
                  "all/1",
                  "change/1",
                  "create/1",
                  "create!/1",
                  "delete/1",
                  "delete!/1",
                  "get/2",
                  "get!/2",
                  "get_by/2",
                  "get_by!/2",
                  "update/2",
                  "update!/2"
                ]}
             ]
    end
  end
end
