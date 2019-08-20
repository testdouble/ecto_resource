defmodule EctoResource do
  @moduledoc """
  This module represents the generic CRUD functionality that is boilerplate within
  Phoenix context files. It provides a DSL to easily generate the basic functions
  for a schema. This allows the context to focus on interesting, atypical implementations
  rather than the redundent, drifting crud functions.
  """

  alias __MODULE__
  alias EctoResource.{OptionParser, ResourceFunctions, Helpers}
  alias Inflex

  defmacro __using__(_) do
    quote do
      import EctoResource, only: [using_repo: 2]
    end
  end

  defmacro using_repo(repo, do: block) do
    quote do
      Module.register_attribute(__MODULE__, :repo, [])
      Module.put_attribute(__MODULE__, :repo, unquote(repo))
      Module.register_attribute(__MODULE__, :resources, accumulate: true)
      import EctoResource, only: [resource: 2, resource: 1]
      unquote(block)
      def __resource__(:resources), do: @resources
      Module.delete_attribute(__MODULE__, :resources)
      Module.delete_attribute(__MODULE__, :repo)
    end
  end

  defmacro resource(schema, options \\ []) do
    quote bind_quoted: [schema: schema, options: options] do
      suffix = Helpers.underscore_module_name(schema)
      resources = OptionParser.parse(suffix, options)

      Module.put_attribute(
        __MODULE__,
        :resources,
        {@repo, schema, Helpers.resource_descriptions(resources)}
      )

      resources
      |> Map.keys()
      |> Enum.each(fn action ->
        action = Map.put(%{}, action, resources[action])

        case action do
          %{all: %{name: name}} ->
            def unquote(name)(options \\ []),
              do: ResourceFunctions.all(@repo, unquote(schema), options)

          %{change: %{name: name}} ->
            def unquote(name)(struct_or_changeset),
              do: ResourceFunctions.change(unquote(schema), struct_or_changeset)

          %{create: %{name: name}} ->
            def unquote(name)(attributes),
              do: ResourceFunctions.create(@repo, unquote(schema), attributes)

          %{create!: %{name: name}} ->
            def unquote(name)(attributes),
              do: ResourceFunctions.create!(@repo, unquote(schema), attributes)

          %{delete: %{name: name}} ->
            def unquote(name)(struct_or_changeset),
              do: ResourceFunctions.delete(@repo, struct_or_changeset)

          %{delete!: %{name: name}} ->
            def unquote(name)(struct_or_changeset),
              do: ResourceFunctions.delete!(@repo, struct_or_changeset)

          %{get: %{name: name}} ->
            def unquote(name)(id, options \\ []),
              do: ResourceFunctions.get(@repo, unquote(schema), id, options)

          %{get!: %{name: name}} ->
            def unquote(name)(id, options \\ []),
              do: ResourceFunctions.get!(@repo, unquote(schema), id, options)

          %{update: %{name: name}} ->
            def unquote(name)(struct, changeset),
              do: ResourceFunctions.update(@repo, unquote(schema), struct, changeset)

          %{update!: %{name: name}} ->
            def unquote(name)(struct, changeset),
              do: ResourceFunctions.update!(@repo, unquote(schema), struct, changeset)

          _ ->
            nil
        end
      end)
    end
  end
end
