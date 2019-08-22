defmodule EctoResource.HelpersTest do
  use ExUnit.Case

  alias EctoResource.Helpers

  describe "schema_name/1" do
    test "returns the string schema name" do
      defmodule MyApp.MySchema do
      end

      assert Helpers.schema_name(MyApp.MySchema) == "MySchema"
    end
  end
end
