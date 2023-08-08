defmodule EctoResource do
  @moduledoc """
  EctoResource
  ============
  Eliminate boilerplate involved in defining basic CRUD functions in a Phoenix context or Elixir module.

  When using [Context modules](https://hexdocs.pm/phoenix/contexts.html) in a [Phoenix](https://phoenixframework.org/) application,
  there's a general need to define the standard CRUD functions for a given `Ecto.Schema`. Phoenix context generators will even do this automatically.
  Soon you will notice that there's quite a lot of code involved in CRUD access within your contexts.

  This can become problematic for a few reasons:

  * Boilerplate functions for CRUD access, for every `Ecto.Schema` referenced in that context, introduce more noise than signal. This can obscure the more interesting details of the context.
  * These functions may tend to accumulate drift from the standard API by inviting edits for new use-cases, reducing the usefulness of naming conventions.
  * The burden of locally testing wrapper functions, yields low value for the writing and maintainence investment.

  In short, at best this code is redundant and at worst is a deviant entanglement of modified conventions. All of which amounts to a more-painful development experience. `EctoResource` was created to ease this pain.

  Usage
  -----

  ### Basic usage - generate all `EctoResource` functions

  ```elixir
  defmodule MyApp.MyContext do
  alias MyApp.Repo
  alias MyApp.Schema
  use EctoResource

  using_repo(Repo) do
    resource(Schema)
  end
  end
  ```

  This generates all the functions `EctoResource` has to offer:

  * `MyContext.all_schemas/1`
  * `MyContext.change_schema/1`
  * `MyContext.create_schema/1`
  * `MyContext.create_schema!/1`
  * `MyContext.delete_schema/1`
  * `MyContext.delete_schema!/1`
  * `MyContext.get_schema/2`
  * `MyContext.get_schema!/2`
  * `MyContext.get_schema_by/2`
  * `MyContext.get_schema_by!/2`
  * `MyContext.update_schema/2`
  * `MyContext.update_schema!/2`

  ### Explicit usage - generate only given functions

  ```elixir
  defmodule MyApp.MyContext do
  alias MyApp.Repo
  alias MyApp.Schema
  use EctoResource

  using_repo(Repo) do
    resource(Schema, only: [:create, :delete!])
  end
  end
  ```

  This generates only the given functions:

  * `MyContext.create_schema/1`
  * `MyContext.delete_schema!/1`

  ### Exclusive usage - generate all but the given functions

  ```elixir
  defmodule MyApp.MyContext do
  alias MyApp.Repo
  alias MyApp.Schema
  use EctoResource

  using_repo(Repo) do
    resource(Schema, except: [:create, :delete!])
  end
  end
  ```

  This generates all the functions excluding the given functions:

  * `MyContext.all_schemas/1`
  * `MyContext.change_schema/1`
  * `MyContext.create_schema!/1`
  * `MyContext.delete_schema/1`
  * `MyContext.get_schema/2`
  * `MyContext.get_schema_by/2`
  * `MyContext.get_schema_by!/2`
  * `MyContext.get_schema!/2`
  * `MyContext.update_schema/2`
  * `MyContext.update_schema!/2`

  ### Alias `:read` - generate data access functions

  ```elixir
  defmodule MyApp.MyContext do
  alias MyApp.Repo
  alias MyApp.Schema
  use EctoResource

  using_repo(Repo) do
    resource(Schema, :read)
  end
  end
  ```

  This generates all the functions necessary for reading data:

  * `MyContext.all_schemas/1`
  * `MyContext.get_schema/2`
  * `MyContext.get_schema!/2`

  ### Alias `:read_write` - generate data access and manipulation functions, excluding delete

  ```elixir
  defmodule MyApp.MyContext do
  alias MyApp.Repo
  alias MyApp.Schema
  use EctoResource

  using_repo(Repo) do
    resource(Schema, :read_write)
  end
  end
  ```

  This generates all the functions except `delete_schema/1` and `delete_schema!/1`:

  * `MyContext.all_schemas/1`
  * `MyContext.change_schema/1`
  * `MyContext.create_schema/1`
  * `MyContext.create_schema!/1`
  * `MyContext.get_schema/2`
  * `MyContext.get_schema!/2`
  * `MyContext.update_schema/2`
  * `MyContext.update_schema!/2`

  ### Resource functions

  The general idea of the generated resource functions is to abstract away the `Ecto.Repo` and `Ecto.Schema` parts of data access with `Ecto` and provide an API to the context that feels natural and clear to the caller.

  The following examples will all assume a repo named `Repo` and a schema named `Person`.

  #### all_people

  Fetches a list of all %Person{} entries from the data store. _Note: `EctoResource` will pluralize this function name using `Inflex`_

  ```elixir
  iex> all_people()
  [%Person{id: 1}]

  iex> all_people(preloads: [:address])
  [%Person{id: 1, address: %Address{}}]

  iex> all_people(order_by: [desc: :id])
  [%Person{id: 2}, %Person{id: 1}]

  iex> all_people(preloads: [:address], order_by: [desc: :id]))
  [
  %Person{
    id: 2,
    address: %Address{}
  },
  %Person{
    id: 1,
    address: %Address{}
  }
  ]

  iex> all_people(where: [id: 2])
  [%Person{id: 2, address: %Address{}}]
  ```

  #### change_person

  Creates a `%Person{}` changeset.

  ```elixir
  iex> change_person(%{name: "Example Person"})
  #Ecto.Changeset<
  action: nil,
  changes: %{name: "Example Person"},
  errors: [],
  data: #Person<>,
  valid?: true
  >
  ```

  #### create_person

  Inserts a `%Person{}` with the given attributes in the data store, returning an `:ok`/`:error` tuple.

  ```elixir
  iex> create_person(%{name: "Example Person"})
  {:ok, %Person{id: 123, name: "Example Person"}}

  iex> create_person(%{invalid: "invalid"})
  {:error, %Ecto.Changeset}
  ```

  #### create_person!

  Inserts a `%Person{}` with the given attributes in the data store, returning a `%Person{}` or raises `Ecto.InvalidChangesetError`.

  ```elixir
  iex> create_person!(%{name: "Example Person"})
  %Person{id: 123, name: "Example Person"}

  iex> create_person!(%{invalid: "invalid"})
  ** (Ecto.InvalidChangesetError)
  ```

  #### delete_person

  Deletes a given `%Person{}` from the data store, returning an `:ok`/`:error` tuple.

  ```elixir
  iex> delete_person(%Person{id: 1})
  {:ok, %Person{id: 1}}

  iex> delete_person(%Person{id: 999})
  {:error, %Ecto.Changeset}
  ```

  #### delete_person!

  Deletes a given `%Person{}` from the data store, returning the deleted `%Person{}`, or raises `Ecto.StaleEntryError`.

  ```elixir
  iex> delete_person!(%Person{id: 1})
  %Person{id: 1}

  iex> delete_person!(%Person{id: 999})
  ** (Ecto.StaleEntryError)
  ```

  #### get_person

  Fetches a single `%Person{}` from the data store where the primary key matches the given id, returns a `%Person{}` or `nil`.

  ```elixir
  iex> get_person(1)
  %Person{id: 1}

  iex> get_person(999)
  nil

  iex> get_person(1, preloads: [:address])
  %Person{
    id: 1,
    address: %Address{}
  }
  ```

  #### get_person!

  Fetches a single `%Person{}` from the data store where the primary key matches the given id, returns a `%Person{}` or raises `Ecto.NoResultsError`.

  ```elixir
  iex> get_person!(1)
  %Person{id: 1}

  iex> get_person!(999)
  ** (Ecto.NoResultsError)

  iex> get_person!(1, preloads: [:address])
  %Person{
    id: 1,
    address: %Address{}
  }
  ```

  #### get_person_by

  Fetches a single `%Person{}` from the data store where the attributes match the
  given values.

  ```elixir
  iex> get_person_by(%{name: "Chuck Norris"})
  %Person{name: "Chuck Norris"}

  iex> get_person_by(%{name: "Doesn't Exist"})
  nil
  ```

  #### get_person_by!

  Fetches a single `%Person{}` from the data store where the attributes match the
  given values. Raises an `Ecto.NoResultsError` if the record does not exist

  ```elixir
  iex> get_person_by!(%{name: "Chuck Norris"})
  %Person{name: "Chuck Norris"}

  iex> get_person_by!(%{name: "Doesn't Exist"})
  ** (Ecto.NoResultsError)
  ```

  #### update_person

  Updates a given %Person{} with the given attributes, returns an `:ok`/`:error` tuple.

  ```elixir
  iex> update_person(%Person{id: 1}, %{name: "New Person"})
  {:ok, %Person{id: 1, name: "New Person"}}

  iex> update_person(%Person{id: 1}, %{invalid: "invalid"})
  {:error, %Ecto.Changeset}
  ```

  #### update_person!

  Updates a given %Person{} with the given attributes, returns a %Person{} or raises `Ecto.InvalidChangesetError`.

  ```elixir
  iex> update_person!(%Person{id: 1}, %{name: "New Person"})
  %Person{id: 1, name: "New Person"}

  iex> update_person!(%Person{id: 1}, %{invalid: "invalid"})
  ** (Ecto.InvalidChangesetError)
  ```

  Caveats
  -------
  This is not meant to be used as a wrapper for all the Repo functions within a context. Not all callbacks defined in Ecto.Repo are generated. `EctoResource` should be used to help reduce boilerplate code and tests for general CRUD operations.

  It may be the case that `EctoResource` needs to evolve and provide slightly more functionality/flexibility in the future. However, the general focus is reducing boilerplate code.
  """

  alias __MODULE__
  alias EctoResource.Helpers
  alias EctoResource.OptionParser
  alias EctoResource.ResourceFunctions

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
        resource(Schema, suffix: false)
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
  # credo:disable-for-next-line
  defmacro resource(schema, options \\ []) do
    # credo:disable-for-next-line
    quote bind_quoted: [schema: schema, options: options] do
      suffix = OptionParser.create_suffix(schema, options)
      schema_name = Helpers.schema_name(schema)
      resources = OptionParser.parse(suffix, options)
      descriptions = Helpers.resource_descriptions(resources)

      Module.put_attribute(__MODULE__, :resources, {@repo, schema, descriptions})

      Enum.each(resources, fn {action, %{name: name}} ->
        case action do
          :all ->
            @doc """
            Fetches all #{schema_name} entries from the data store.

            ## Examples
                #{name}()
                [%#{schema_name}{id: 123}]

                #{name}(preloads: [:relation])
                [%#{schema_name}{id: 123, relation: %Relation{}}]

                #{name}(order_by: [desc: :id])
                [%#{schema_name}{id: 2}, %#{schema_name}{id: 1}]

                #{name}(preloads: [:relation], order_by: [desc: :id])
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
            """
            @spec unquote(name)(keyword(list())) :: list(Ecto.Schema.t())
            def unquote(name)(options \\ []) do
              ResourceFunctions.all(@repo, unquote(schema), options)
            end

          :change ->
            @doc """
            Creates a #{schema_name} changeset from an existing schema struct.

                #{name}(%#{schema_name}{}, %{})

                #Ecto.Changeset<
                  action: nil,
                  changes: %{},
                  errors: [],
                  data: ##{schema_name}<>,
                  valid?: true
                >

                #{name}(%#{schema_name}{}, [])

                #Ecto.Changeset<
                  action: nil,
                  changes: %{},
                  errors: [],
                  data: ##{schema_name}<>,
                  valid?: true
                >

            """
            @spec unquote(name)(Ecto.Schema.t(), map() | Keyword.t()) :: Ecto.Changeset.t()
            def unquote(name)(changeable, changes) do
              ResourceFunctions.change(unquote(schema), changeable, changes)
            end

          :changeset ->
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
            @spec unquote(name)() :: Ecto.Changeset.t()
            def unquote(name)() do
              ResourceFunctions.changeset(unquote(schema))
            end

          :create ->
            @doc """
            Inserts a #{schema_name} with the given attributes in the data store.

            ## Examples
                #{name}(%{})
                {:ok, %#{schema_name}{}}

                #{name}([])
                {:ok, %#{schema_name}{}}

                #{name}(%{invalid: "invalid"})
                  {:error, %Ecto.Changeset{}}
            """
            @spec unquote(name)(map() | Keyword.t()) ::
                    {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
            def unquote(name)(attributes) do
              ResourceFunctions.create(@repo, unquote(schema), attributes)
            end

          :create! ->
            @doc """
            Same as create_#{suffix}/1 but returns the struct or raises if the changeset is invalid.

            ## Examples
                #{name}(%{})
                %#{schema_name}{}

                #{name}([])
                %#{schema_name}{}

                #{name}(%{invalid: "invalid"})
                ** (Ecto.InvalidChangesetError)
            """
            @spec unquote(name)(map() | Keyword.t()) ::
                    Ecto.Schema.t() | Ecto.InvalidChangesetError
            def unquote(name)(attributes) do
              ResourceFunctions.create!(@repo, unquote(schema), attributes)
            end

          :delete ->
            @doc """
            Deletes a given %#{schema_name}{} from the data store.

            ## Examples
                #{name}(%#{schema_name}{id: 123})
                {:ok, %#{schema_name}{id: 123}}

                #{name}(%#{schema_name}{id: 456})
                {:error, %Ecto.Changeset{}}

            """
            @spec unquote(name)(Ecto.Schema.t()) ::
                    {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
            def unquote(name)(struct) do
              ResourceFunctions.delete(@repo, struct)
            end

          :delete! ->
            @doc """
            Same as delete_#{suffix}/1 but returns the struct or raises if the changeset is invalid.

            ## Examples
                #{name}(%#{schema_name}{id: 123})
                %#{schema_name}{id: 123}

                #{name}(%#{schema_name}{id: 456})
                ** (Ecto.StaleEntryError)
            """
            def unquote(name)(struct) do
              ResourceFunctions.delete!(@repo, struct)
            end

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
                  id: 1,
                  relation: %Relation{}
                }
            """
            @spec unquote(name)(String.t() | integer(), keyword(list())) :: Ecto.Schema.t() | nil
            def unquote(name)(id, options \\ []) do
              ResourceFunctions.get(@repo, unquote(schema), id, options)
            end

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
                  id: 1,
                  relation: %Relation{}
                }
            """
            def unquote(name)(id, options \\ []) do
              ResourceFunctions.get!(@repo, unquote(schema), id, options)
            end

          :get_by ->
            @doc """
            Fetches a single result from the query.

            Returns nil if no result was found. Raises if more than one entry.

            ## Examples
                #{name}(name: "Some Name")
                %#{schema_name}{name: "Some Name"}

                #{name}(%{name: "Some Name"})
                %#{schema_name}{name: "Some Name"}

                #{name}(name: "Missing")
                nil
            """
            def unquote(name)(attributes, options \\ []) do
              ResourceFunctions.get_by(@repo, unquote(schema), attributes, options)
            end

          :get_by! ->
            @doc """
            Similar to get_by/2 but raises Ecto.NoResultsError if no record was found.

            Raises if more than one entry.

            ## Examples
                #{name}(name: "Some Name")
                %#{schema_name}{name: "Some Name"}

                #{name}(%{name: "Some Name"})
                %#{schema_name}{name: "Some Name"}

                #{name}(name: "Missing")
                ** (Ecto.NoResultsError)
            """
            def unquote(name)(attributes, options \\ []) do
              ResourceFunctions.get_by!(@repo, unquote(schema), attributes, options)
            end

          :update ->
            @doc """
            Updates a %#{schema_name}{} with the given attributes.

            ## Examples
                #{name}(%#{schema_name}{id: 123}, %{attribute: "updated attribute"})
                {:ok, %#{schema_name}{id: 123, attribute: "updated attribute"}}

                #{name}(%#{schema_name}{id: 123}, attribute: "updated attribute")
                {:ok, %#{schema_name}{id: 123, attribute: "updated attribute"}}

                #{name}(%#{schema_name}{id: 123}, %{}, force: true)
                {:ok, %#{schema_name}{id: 123, attribute: "updated attribute"}}

                #{name}(%#{schema_name}{id: 123}, %{}, prefix: "my_prefix")
                {:ok, %#{schema_name}{id: 123, attribute: "updated attribute"}}

                #{name}(%#{schema_name}{id: 123}, %{invalid: "invalid"})
                {:error, %Ecto.Changeset{}}
            """
            @spec unquote(name)(Ecto.Schema.t(), map() | Keyword.t()) ::
                    {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
            def unquote(name)(struct, attributes) do
              ResourceFunctions.update(@repo, unquote(schema), struct, attributes)
            end

            @doc """
            Same as update_#{suffix}/2 returns a %#{schema_name}{} or raises if the changeset is invalid.

            ## Examples
                #{name}(%#{schema_name}{id: 123}, %{attribute: "updated attribute"})
                %#{schema_name}{id: 123, attribute: "updated attribute"}

                #{name}(%#{schema_name}{id: 123}, %{}, force: true)
                %#{schema_name}{id: 123, attribute: "updated attribute"}

                #{name}(%#{schema_name}{id: 123}, %{}, prefix: "my_prefix")
                %#{schema_name}{id: 123, attribute: "updated attribute"}

                #{name}(%#{schema_name}{id: 123}, %{invalid: "invalid"})
                ** (Ecto.InvalidChangesetError)
            """

          :update! ->
            @spec unquote(name)(Ecto.Schema.t(), map() | Keyword.t()) ::
                    Ecto.Schema.t() | Ecto.InvalidChangesetError
            def unquote(name)(struct, attributes) do
              ResourceFunctions.update!(@repo, unquote(schema), struct, attributes)
            end

          _ ->
            nil
        end
      end)
    end
  end
end
