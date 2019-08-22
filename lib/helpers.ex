defmodule EctoResource.Helpers do
  @moduledoc """
  This module represents the generic CRUD functionality that is boilerplate within
  Phoenix context files. It provides a DSL to easily generate the basic functions
  for a schema. This allows the context to focus on interesting, atypical implementations
  rather than the redundent, drifting crud functions.
  """

  @doc """
  Get an underscored module name for use in generating functions.

  ## Examples
      iex> underscore_module_name(MyModule)

      "my_module"
  """
  @spec underscore_module_name(module) :: String.t()
  def underscore_module_name(module) do
    module
    |> Macro.underscore()
    |> String.split("/")
    |> List.last()
  end

  @doc """
  Get a list of all function descriptions.

  ## Examples
      iex> resource_descriptions(%{all: %{description: "all/1"}, %{change: %{description: "change/1"}})

      ["all/1", "change/1"]
  """
  @spec resource_descriptions(term()) :: list(String.t())
  def resource_descriptions(resources) do
    resources
    |> Map.values()
    |> Enum.map(& &1.description)
  end

  @doc """
  Get the string version of the schema name

  ## Examples
      iex> schema_name(User)
      "User"
  """
  @spec schema_name(module()) :: String.t()
  def schema_name(schema) do
    schema
    |> Macro.to_string()
    |> String.split(".")
    |> List.last()
  end
end
