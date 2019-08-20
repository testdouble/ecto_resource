defmodule EctoResource.Helpers do
  @doc """
  Get an underscored module name for use in generating functions.

  ## Examples
      iex> underscore_module_name(User)

      "user"
  """
  @spec underscore_module_name(module) :: String.t()
  def underscore_module_name(module) do
    module
    |> Macro.underscore()
    |> String.split("/")
    |> List.last()
  end

  def resource_descriptions(resources) do
    resources
    |> Map.values()
    |> Enum.map(& &1.description)
  end
end
