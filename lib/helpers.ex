defmodule EctoCooler.Helpers do
  @moduledoc false

  @spec underscore_module_name(module) :: String.t()
  def underscore_module_name(module) do
    module
    |> Macro.underscore()
    |> String.split("/")
    |> List.last()
  end

  @spec resource_descriptions(term()) :: list(String.t())
  def resource_descriptions(resources) do
    resources
    |> Map.values()
    |> Enum.map(& &1.description)
  end

  @spec schema_name(module()) :: String.t()
  def schema_name(schema) do
    schema
    |> Macro.to_string()
    |> String.split(".")
    |> List.last()
  end
end
