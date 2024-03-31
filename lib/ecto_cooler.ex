defmodule EctoCooler do
  @moduledoc """
  This module provides a DSL to easily generate the basic functions for a schema.
  This allows the context to focus on interesting, atypical implementations rather
  than the redundent, drifting CRUD functions.
  """

  alias __MODULE__
  alias EctoCooler.Helpers
  alias EctoCooler.OptionParser
  alias EctoCooler.ResourceFunctions

  @doc """
  Macro to import `EctoCooler.using_repo/2`

  ## Examples
      use EctoCooler
  """
  defmacro __using__(_) do
    quote do
      import EctoCooler, only: [using_repo: 2]
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
      import EctoCooler, only: [resource: 2, resource: 1]
      unquote(block)
      def __resource__(:resources), do: @resources
      Module.delete_attribute(__MODULE__, :resources)
      Module.delete_attribute(__MODULE__, :repo)
    end
  end

  @doc """
  Macro to define CRUD methods for the given `Ecto.Repo` in the using module.

  ## Examples
      ### Generate a complete set of resource functions, suffix defaults to false
      using(Repo) do
        resource(Schema)
      end

      ### Generate a complete set of resource functions, with a _<resource_name> suffix (ie. Posts.get_post_by, Posts.get_post, etc.)
      using(Repo) do
        resource(Schema, suffix: true)
      end

      ### Generate only a given list of functions
      using(Repo) do
        resource(Schema, only: [:get])
      end

      ### Generate every function except those in the given list
      using(Repo) do
        resource(Schema, except: [:delete])
      end

      ### Generate all read operation functions
      using(Repo) do
        resource(Schema, :read)
      end

      ### Generate all write (includes read) operation functions
      using(Repo) do
        resource(Schema, :write)
      end

      ### Generate only delete functions
      using(Repo) do
        resource(Schema, :delete)
      end
  """
  defmacro resource(schema, options \\ [suffix: false]) do
    quote bind_quoted: [schema: schema, options: options] do
      suffix = OptionParser.create_suffix(schema, options)
      schema_name = Helpers.schema_name(schema)
      functions = OptionParser.parse(suffix, options)
      descriptions = Helpers.resource_descriptions(functions)

      Module.put_attribute(__MODULE__, :resources, {@repo, schema, descriptions})

      if all = Map.get(functions, :all, nil) do
        @doc """
        Fetches all #{schema_name} entries from the data store.

        ## Examples
            #{all.name}()
            [%#{schema_name}{id: 123}]

            #{all.name}(preloads: [:relation])
            [%#{schema_name}{id: 123, relation: %Relation{}}]

            #{all.name}(order_by: [desc: :id])
            [%#{schema_name}{id: 2}, %#{schema_name}{id: 1}]

            #{all.name}(preloads: [:relation], order_by: [desc: :id])
            [
              %#{schema_name}{
                id: 2,
                relation: %Relation{}
              },
              %#{schema_name}{
                id: 1,
                relation: %Relation{}
              }
            ]

            #{all.name}(where: [active: true])
            [
              %#{schema_name}{
                id: 1,
                active: true
              },
              %#{schema_name}{
                id: 42,
                active: true
              }
            ]
        """
        @spec unquote(all.name)(keyword(list())) :: list(Ecto.Schema.t())
        def unquote(all.name)(options \\ []) do
          ResourceFunctions.all(@repo, unquote(schema), options)
        end
      end

      if change = Map.get(functions, :change, nil) do
        @doc """
        Creates a #{schema_name} changeset from an existing schema struct.

            #{change.name}(%#{schema_name}{}, %{})

            #Ecto.Changeset<
              action: nil,
              changes: %{},
              errors: [],
              data: ##{schema_name}<>,
              valid?: true
            >

            #{change.name}(%#{schema_name}{}, [])

            #Ecto.Changeset<
              action: nil,
              changes: %{},
              errors: [],
              data: ##{schema_name}<>,
              valid?: true
            >

        """
        @spec unquote(change.name)(Ecto.Schema.t(), map() | Keyword.t()) :: Ecto.Changeset.t()
        def unquote(change.name)(changeable, changes) do
          ResourceFunctions.change(unquote(schema), changeable, changes)
        end
      end

      if changeset = Map.get(functions, :changeset, nil) do
        @doc """
        Creates a blank changeset.

            changeset()

            #Ecto.Changeset<
              action: nil,
              changes: %{},
              errors: [],
              data: ##{schema_name}<>,
              valid?: true
            >
        """
        @spec unquote(changeset.name)() :: Ecto.Changeset.t()
        def unquote(changeset.name)() do
          ResourceFunctions.changeset(unquote(schema))
        end
      end

      if create = Map.get(functions, :create, nil) do
        @doc """
        Inserts a #{schema_name} with the given attributes in the data store.

        ## Examples
            #{create.name}(%{})
            {:ok, %#{schema_name}{}}

            #{create.name}([])
            {:ok, %#{schema_name}{}}

            #{create.name}(%{invalid: "invalid"})
              {:error, %Ecto.Changeset{}}
        """
        @spec unquote(create.name)(map() | Keyword.t()) ::
                {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
        def unquote(create.name)(attributes) do
          ResourceFunctions.create(@repo, unquote(schema), attributes)
        end
      end

      if create = Map.get(functions, :create!, nil) do
        @doc """
        Same as #{get_in(functions, [:create, :name])}/1 but returns the struct or raises if the changeset is invalid.

        ## Examples
            #{create.name}(%{})
            %#{schema_name}{}

            #{create.name}([])
            %#{schema_name}{}

            #{create.name}(%{invalid: "invalid"})
            ** (Ecto.InvalidChangesetError)
        """
        @spec unquote(create.name)(map() | Keyword.t()) ::
                Ecto.Schema.t() | Ecto.InvalidChangesetError
        def unquote(create.name)(attributes) do
          ResourceFunctions.create!(@repo, unquote(schema), attributes)
        end
      end

      if delete = Map.get(functions, :delete, nil) do
        @doc """
        Deletes a given %#{schema_name}{} from the data store.

        ## Examples
            #{delete.name}(%#{schema_name}{id: 123})
            {:ok, %#{schema_name}{id: 123}}

            #{delete.name}(%#{schema_name}{id: 456})
            {:error, %Ecto.Changeset{}}

        """
        @spec unquote(delete.name)(Ecto.Schema.t()) ::
                {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
        def unquote(delete.name)(struct) do
          ResourceFunctions.delete(@repo, struct)
        end
      end

      if delete = Map.get(functions, :delete!, nil) do
        @doc """
        Same as #{get_in(functions, [:delete, :name])}/1 but returns the struct or raises if the changeset is invalid.

        ## Examples
            #{delete.name}(%#{schema_name}{id: 123})
            %#{schema_name}{id: 123}

            #{delete.name}(%#{schema_name}{id: 456})
            ** (Ecto.StaleEntryError)
        """
        def unquote(delete.name)(struct) do
          ResourceFunctions.delete!(@repo, struct)
        end
      end

      if get = Map.get(functions, :get, nil) do
        @doc """
        Fetches a single #{schema_name} from the data store where the primary key matches the given id.

        ## Examples
            #{get.name}(123)
            %#{schema_name}{id: 123}

            #{get.name}(456)
            nil

            #{get.name}(123, preloads: [:relation])
            %#{schema_name}{
              id: 1,
              relation: %Relation{}
            }
        """
        @spec unquote(get.name)(String.t() | integer(), keyword(list())) :: Ecto.Schema.t() | nil
        def unquote(get.name)(id, options \\ []) do
          ResourceFunctions.get(@repo, unquote(schema), id, options)
        end
      end

      if get = Map.get(functions, :get!, nil) do
        @doc """
        Returns a single resource, raises Ecto.NoResultsError if no  record was found

        ## Examples
            #{get.name}(123)
            %#{schema_name}{id: 123}

            #{get.name}(456)
            ** (Ecto.NoResultsError)

            #{get.name}(123, preloads: [:relation])
            %#{schema_name}{
              id: 1,
              relation: %Relation{}
            }
        """
        def unquote(get.name)(id, options \\ []) do
          ResourceFunctions.get!(@repo, unquote(schema), id, options)
        end
      end

      if get_by = Map.get(functions, :get_by, nil) do
        @doc """
        Fetches a single result, returns nil if no result was found.
        ## Examples
            #{get_by.name}(name: "Some Name")
            %#{schema_name}{name: "Some Name"}

            #{get_by.name}(%{name: "Some Name"})
            %#{schema_name}{name: "Some Name"}

            #{get_by.name}(name: "Missing")
            nil
        """
        def unquote(get_by.name)(attributes, options \\ []) do
          ResourceFunctions.get_by(@repo, unquote(schema), attributes, options)
        end
      end

      if get_by = Map.get(functions, :get_by!, nil) do
        @doc """
        Fetches a single result matching the given parameters, raises Ecto.NoResultsError if no result was found.

        ## Examples
            #{get_by.name}(name: "Some Name")
            %#{schema_name}{name: "Some Name"}

            #{get_by.name}(%{name: "Some Name"})
            %#{schema_name}{name: "Some Name"}

            #{get_by.name}(name: "Missing")
            ** (Ecto.NoResultsError)
        """
        def unquote(get_by.name)(attributes, options \\ []) do
          ResourceFunctions.get_by!(@repo, unquote(schema), attributes, options)
        end
      end

      if update = Map.get(functions, :update, nil) do
        @doc """
        Updates a %#{schema_name}{} with the given attributes.

        ## Examples
            #{update.name}(%#{schema_name}{id: 123}, %{attribute: "updated attribute"})
            {:ok, %#{schema_name}{id: 123, attribute: "updated attribute"}}

            #{update.name}(%#{schema_name}{id: 123}, attribute: "updated attribute")
            {:ok, %#{schema_name}{id: 123, attribute: "updated attribute"}}

            #{update.name}(%#{schema_name}{id: 123}, %{}, force: true)
            {:ok, %#{schema_name}{id: 123, attribute: "updated attribute"}}

            #{update.name}(%#{schema_name}{id: 123}, %{}, prefix: "my_prefix")
            {:ok, %#{schema_name}{id: 123, attribute: "updated attribute"}}

            #{update.name}(%#{schema_name}{id: 123}, %{invalid: "invalid"})
            {:error, %Ecto.Changeset{}}
        """
        @spec unquote(update.name)(Ecto.Schema.t(), map() | Keyword.t()) ::
                {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
        def unquote(update.name)(struct, attributes) do
          ResourceFunctions.update(@repo, unquote(schema), struct, attributes)
        end
      end

      if update = Map.get(functions, :update!, nil) do
        @doc """
        Updates a %#{schema_name}{} with the given attributes, raises Ecto.InvalidChangesetError if invalid.

        ## Examples
            #{update.name}(%#{schema_name}{id: 123}, %{attribute: "updated attribute"})
            %#{schema_name}{id: 123, attribute: "updated attribute"}

            #{update.name}(%#{schema_name}{id: 123}, %{}, force: true)
            %#{schema_name}{id: 123, attribute: "updated attribute"}

            #{update.name}(%#{schema_name}{id: 123}, %{}, prefix: "my_prefix")
            %#{schema_name}{id: 123, attribute: "updated attribute"}

            #{update.name}(%#{schema_name}{id: 123}, %{invalid: "invalid"})
            ** (Ecto.InvalidChangesetError)
        """

        @spec unquote(update.name)(Ecto.Schema.t(), map() | Keyword.t()) ::
                Ecto.Schema.t() | Ecto.InvalidChangesetError
        def unquote(update.name)(struct, attributes) do
          ResourceFunctions.update!(@repo, unquote(schema), struct, attributes)
        end
      end
    end
  end
end
