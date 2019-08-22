defmodule EctoResource do
  @moduledoc """
  This module provides a DSL to easily generate the basic functions for a schema.
  This allows the context to focus on interesting, atypical implementations rather
  than the redundent, drifting CRUD functions.
  """

  alias __MODULE__
  alias EctoResource.{Helpers, OptionParser, ResourceFunctions}

  @doc """
  Macro to import `EctoResource.using_repo/2`

  ## Examples
      use EctoResource
  """
  defmacro __using__(_) do
    quote do
      import EctoResource, only: [using_repo: 2]
    end
  end

  @doc """
  Macro to define schema access within a given `Ecto.Repo`

  ## Examples
      using_repo(Repo) do
        resource(Schema)
      end
  """
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

  @doc """
  Macro to define CRUD methods for the given `Ecto.Repo` in the using module.

  ## Examples
      using(Repo) do
        resource(Schema)
      end

      using(Repo) do
        resource(Schema, only: [:get])
      end

      using(Repo) do
        resource(Schema, except: [:delete])
      end

      using(Repo) do
        resource(Schema, :read)
      end

      using(Repo) do
        resource(Schema, :write)
      end

      using(Repo) do
        resource(Schema, :delete)
      end
  """
  defmacro resource(schema, options \\ []) do
    quote bind_quoted: [schema: schema, options: options] do
      suffix = Helpers.underscore_module_name(schema)
      schema_name = Helpers.schema_name(schema)
      resources = OptionParser.parse(suffix, options)
      descriptions = Helpers.resource_descriptions(resources)

      Module.put_attribute(__MODULE__, :resources, {@repo, schema, descriptions})

      resources
      |> Enum.each(fn {action, %{name: name}} ->
        case action do
          :all ->
            @doc """
            Returns a list of #{unquote(schema_name)} schemas.

            ## Examples
                #{unquote(schema_name)}.all()
                [%#{unquote(schema_name)}{id: 123}]
            """
            def unquote(name)(options \\ []),
              do: ResourceFunctions.all(@repo, unquote(schema), options)

          :change ->
            def unquote(name)(struct_or_changeset),
              do: ResourceFunctions.change(unquote(schema), struct_or_changeset)

          :create ->
            def unquote(name)(attributes),
              do: ResourceFunctions.create(@repo, unquote(schema), attributes)

          :create! ->
            def unquote(name)(attributes),
              do: ResourceFunctions.create!(@repo, unquote(schema), attributes)

          :delete ->
            def unquote(name)(struct_or_changeset),
              do: ResourceFunctions.delete(@repo, struct_or_changeset)

          :delete! ->
            def unquote(name)(struct_or_changeset),
              do: ResourceFunctions.delete!(@repo, struct_or_changeset)

          :get ->
            def unquote(name)(id, options \\ []),
              do: ResourceFunctions.get(@repo, unquote(schema), id, options)

          :get! ->
            def unquote(name)(id, options \\ []),
              do: ResourceFunctions.get!(@repo, unquote(schema), id, options)

          :update ->
            def unquote(name)(struct, changeset),
              do: ResourceFunctions.update(@repo, unquote(schema), struct, changeset)

          :update! ->
            def unquote(name)(struct, changeset),
              do: ResourceFunctions.update!(@repo, unquote(schema), struct, changeset)

          _ ->
            nil
        end
      end)
    end
  end
end
