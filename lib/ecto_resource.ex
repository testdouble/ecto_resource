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
            Fetches all #{schema_name} entries from the data store.

            ## Examples
                #{name}()
                [%#{schema_name}{id: 123}]

                #{name}(prefix: "my_prefix")
                [%#{schema_name}{id: 123}]

                #{name}(max_rows: 500)
                [%#{schema_name}{id: 123}]
            """
            @spec unquote(name)(keyword(list())) :: list(Ecto.Schema.t())
            def unquote(name)(options \\ []),
              do: ResourceFunctions.all(@repo, unquote(schema), options)

          :change ->
            @doc """
            Creates a #{schema_name} changeset.

                #{name}(%#{schema_name}{}, %{})

                #Ecto.Changeset<
                  action: nil,
                  changes: %{},
                  errors: [],
                  data: ##{schema_name}<>,
                  valid?: true
                >

            """
            @spec unquote(name)(map()) :: Ecto.Changeset.t()
            def unquote(name)(attributes),
              do: ResourceFunctions.change(unquote(schema), attributes)

          :create ->
            @doc """
            Creates a #{schema_name} with the given attributes.

            ## Examples
                #{name}(%{})
                {:ok, %#{schema_name}{}}

                #{name}(%{invalid: "invalid"})
                {:error, %Ecto.Changeset{}}
            """
            @spec unquote(name)(map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
            def unquote(name)(attributes),
              do: ResourceFunctions.create(@repo, unquote(schema), attributes)

          :create! ->
            @doc """
            Same as create_#{suffix}/1 but returns the struct or raises if the changeset is invalid.

            ## Examples
                #{name}(%{})
                %#{schema_name}{}

                #{name}(%{invalid: "invalid"})
                ** (Ecto.InvalidChangesetError)
            """
            def unquote(name)(attributes),
              do: ResourceFunctions.create!(@repo, unquote(schema), attributes)

          :delete ->
            @doc """
            Deletes a given record from the data store.

            ## Examples
                #{name}(%#{schema_name}{id: 123})
                {:ok,
                 %#{schema_name}{
                   __meta__: #Ecto.Schema.Metadata<:deleted, "#{schema.__schema__(:source)}">,
                   id: 123,
                   inserted_at: ~N[2019-08-17 00:41:41],
                   updated_at: ~N[2019-08-17 00:41:41]
                 }}

                 #{name}(%#{schema_name}{id: 456})
                 {:error, %Ecto.Changeset{}}

            """
            @spec unquote(name)(Ecto.Schema.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
            def unquote(name)(struct),
              do: ResourceFunctions.delete(@repo, struct)

          :delete! ->
            @doc """
            Same as delete_#{suffix}/1 but returns the struct or raises if the changeset is invalid.

            ## Examples
                #{name}(%#{schema_name}{id: 123})
                %#{schema_name}{
                  __meta__: #Ecto.Schema.Metadata<:deleted, "#{schema.__schema__(:source)}">,
                  id: 123,
                  inserted_at: ~N[2019-08-17 00:41:41],
                  updated_at: ~N[2019-08-17 00:41:41]
                }

                #{name}(%#{schema_name}{id: 456})
                ** (Ecto.StaleEntryError)
            """
            def unquote(name)(struct),
              do: ResourceFunctions.delete!(@repo, struct)

          :get ->
            @doc """
            Fetches a single #{schema_name} from the data store where the primary key matches the given id.

            ## Examples
                #{name}(123)
                %#{schema_name}{id: 123}

                #{name}(456)
                nil

                #{name}(123, preloads: [:relation])
                %#{schema_name}{
                   __meta__: #Ecto.Schema.Metadata<:loaded, "#{schema.__schema__(:source)}">,
                   id: 1,
                   relation: %Relation{
                     __meta__: #Ecto.Schema.Metadata<:loaded, "relations">,
                   },
                   inserted_at: ~N[2019-08-15 18:52:50],
                   updated_at: ~N[2019-08-15 18:52:50]
                 }
            """
            @spec unquote(name)(String.t() | integer(), keyword(list())) :: Ecto.Schema.t() | nil
            def unquote(name)(id, options \\ []),
              do: ResourceFunctions.get(@repo, unquote(schema), id, options)

          :get! ->
            @doc """
            Same as get_#{suffix}/2 but raises Ecto.NoResultsError if no record was found.

            ## Examples
                #{name}(123)
                %#{schema_name}{id: 123}

                #{name}(456)
                ** (Ecto.NoResultsError)

                #{name}(123, preloads: [:relation])
                %#{schema_name}{
                   __meta__: #Ecto.Schema.Metadata<:loaded, "#{schema.__schema__(:source)}">,
                   id: 1,
                   relation: %Relation{
                     __meta__: #Ecto.Schema.Metadata<:loaded, "relations">,
                   },
                   inserted_at: ~N[2019-08-15 18:52:50],
                   updated_at: ~N[2019-08-15 18:52:50]
                 }
            """
            def unquote(name)(id, options \\ []),
              do: ResourceFunctions.get!(@repo, unquote(schema), id, options)

          :update ->
            @doc """
            Updates a %#{schema_name}{} with the given attributes.

            ## Examples
                #{name}(%#{schema_name}{id: 123}, %{attribute: "updated attribute"})
                {:ok, %#{schema_name}{id: 123, attribute: "updated attribute"}}

                #{name}(%#{schema_name}{id: 123}, %{}, force: true)
                {:ok, %#{schema_name}{id: 123, attribute: "updated attribute"}}

                #{name}(%#{schema_name}{id: 123}, %{}, prefix: "my_prefix")
                {:ok, %#{schema_name}{id: 123, attribute: "updated attribute"}}

                #{name}(%#{schema_name}{id: 123}, %{invalid: "invalid"})
                {:error, %Ecto.Changeset{}}
            """
            @spec unquote(name)(Ecto.Schema.t(), map()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
            def unquote(name)(struct, attributes),
              do: ResourceFunctions.update(@repo, unquote(schema), struct, attributes)

          @doc """
          Same as update_#{suffix}/2 returns a %#{schema_name}{} or raises if the changeset is invalid.

          ## Examples
              #{name}(%#{schema_name}{id: 123}, %{attribute: "updated attribute"})
              {:ok, %#{schema_name}{id: 123, attribute: "updated attribute"}}

              #{name}(%#{schema_name}{id: 123}, %{}, force: true)
              {:ok, %#{schema_name}{id: 123, attribute: "updated attribute"}}

              #{name}(%#{schema_name}{id: 123}, %{}, prefix: "my_prefix")
              {:ok, %#{schema_name}{id: 123, attribute: "updated attribute"}}

              #{name}(%#{schema_name}{id: 123}, %{invalid: "invalid"})
              ** (Ecto.InvalidChangesetError)
          """
          :update! ->
            def unquote(name)(struct, attributes),
              do: ResourceFunctions.update!(@repo, unquote(schema), struct, attributes)

          _ ->
            nil
        end
      end)
    end
  end
end
