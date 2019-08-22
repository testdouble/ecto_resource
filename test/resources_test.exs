defmodule Mix.Tasks.EctoResource.ResourcesTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  alias Mix.Tasks.EctoResource.Resources
  alias MockRepo

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

  describe "for a resource context" do
    defmodule FakeContext do
      use EctoResource

      using_repo(MockRepo) do
        resource(FakeData)
      end
    end

    test "prints generated functions for resource" do
      repo_name = "Elixir.MockRepo"
      context_name = "Mix.Tasks.EctoResource.ResourcesTest.FakeContext"
      schema_name = "Mix.Tasks.EctoResource.ResourcesTest.FakeData"

      log = capture_log([level: :info], fn -> Resources.run([context_name]) end)

      assert log =~ "Within the context #{context_name}"
      assert log =~ "#{schema_name} using the repo #{repo_name}"
      assert log =~ "- #{context_name}.create_fake_data/1"
    end
  end

  describe "without a context provided" do
    test "prints a helpful message" do
      assert capture_log([level: :error], fn -> Resources.run([]) end) =~
               "$ mix ecto_resource.resources MyApp.MyContext"
    end
  end
end
