defmodule EctoResource do
  @moduledoc """
  This module represents the generic CRUD functionality that is boilerplate within
  Phoenix context files. It provides a DSL to easily generate the basic functions
  for a schema. This allows the context to focus on interesting, atypical implementations
  rather than the redundent, drifting crud functions.
  """

  import Ecto.Query

  alias __MODULE__
  alias EctoResource.OptionParser
  alias Inflex

  @doc """
  Creates a changeset for a given Schema

      iex> change(%User{email: "user@example.com"}, %{email: "updated-email@example.com"})

      #Ecto.Changeset<
        action: nil,
        changes: %{},
        errors: [],
        data: #Engine.BusinessPartners.BusinessPartner<>,
        valid?: true
      >

  """
  @spec change(module, Ecto.Schema.t()) :: Ecto.Changeset.t()
  def change(schema, changable) do
    changable
    |> schema.changeset(%{})
  end

  @doc """
  Creates a new record with the given changeset

  ## Examples
      iex> create(Repo, User, %{email: "user@example.com"})

      {:ok,
       %User{
         __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
         inserted_at: ~N[2019-08-17 00:41:41],
         email: "example@example.com",
         updated_at: ~N[2019-08-17 00:41:41]
       }}

  """
  @spec create(Ecto.Repo.t(), module, map()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create(repo, schema, attributes) do
    schema
    |> struct()
    |> schema.changeset(attributes)
    |> repo.insert([])
  end

  @doc """
  Same as create/3 but returns the struct or raises if the changeset is invalid.
  """
  @spec create!(Ecto.Repo.t(), module, map()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def create!(repo, schema, attributes) do
    schema
    |> struct()
    |> schema.changeset(attributes)
    |> repo.insert!([])
  end

  @doc """
  Deletes a given Schema struct

  ## Examples
      iex> delete(Repo, %User{id: 1})

      {:ok,
       %User{
         __meta__: #Ecto.Schema.Metadata<:deleted, "users">,
         id: 1,
         inserted_at: ~N[2019-08-17 00:41:41],
         email: "example@example.com",
         updated_at: ~N[2019-08-17 00:41:41]
       }}

  """
  @spec delete(Ecto.Repo.t(), Ecto.Schema.t()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete(repo, deletable) do
    deletable
    |> repo.delete([])
  end

  @doc """
  Same as delete/2 but returns the struct or raises if the changeset is invalid.
  """
  @spec delete!(Ecto.Repo.t(), Ecto.Schema.t()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete!(repo, deletable) do
    deletable
    |> repo.delete!([])
  end

  @doc """
  Gets a Schema struct by the given id. Can also take options to alter the
  resulting query.

  ## Examples
      iex> get(Repo, User, 1)

      %User{
        __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
        id: 1,
        inserted_at: ~N[2019-08-15 18:52:50],
        email: "example@example.com",
        updated_at: ~N[2019-08-15 18:52:50]
      }

  """
  @spec get(Ecto.Repo.t(), module, term(), term()) :: Ecto.Schema.t() | nil
  def get(repo, schema, id, options \\ []) do
    preloads = Keyword.get(options, :preloads, [])

    schema
    |> preload(^preloads)
    |> repo.get(id, [])
  end

  @doc """
  Same as get/4 but raises Ecto.NoResultsError if no record was found.
  """
  @spec get!(Ecto.Repo.t(), module, term(), term()) :: Ecto.Schema.t() | nil
  def get!(repo, schema, id, options \\ []) do
    preloads = Keyword.get(options, :preloads, [])

    schema
    |> preload(^preloads)
    |> repo.get!(id, [])
  end

  @doc """
  Returns a list of all the records for a given Schema.

  ## Examples
      iex> all(Repo, User)

      [
        %User{
          __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
          id: 1,
          inserted_at: ~N[2019-08-15 18:52:50],
          email: "example@example.com",
          updated_at: ~N[2019-08-15 18:52:50]
        }
      ]
  """
  @spec all(Ecto.Repo.t(), module, term()) :: list(Ecto.Schema.t())
  def all(repo, schema, options \\ []) do
    preloads = Keyword.get(options, :preloads, [])
    order_by = Keyword.get(options, :order_by, [])

    schema
    |> preload(^preloads)
    |> order_by(^order_by)
    |> repo.all([])
  end

  @doc """
  Updates a given Schema with the given attributes

  ## Examples
      iex> update(Repo, User, %User{id: 1}, %{email: "updated@example.com"})

      {:ok,
       %User{
          __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
          id: 1,
          inserted_at: ~N[2019-08-15 18:52:50],
          email: "updated@example.com",
          updated_at: ~N[2019-08-17 01:16:01]
       }}

  """
  @spec update(Ecto.Repo.t(), module, Ecto.Schema.t(), map()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def update(repo, schema, updateable, attributes) do
    updateable
    |> schema.changeset(attributes)
    |> repo.update([])
  end

  @doc """
  Same as update/4 but returns the struct or raises if the changeset is invalid.
  """
  @spec update!(Ecto.Repo.t(), module, Ecto.Schema.t(), map()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def update!(repo, schema, updateable, attributes) do
    updateable
    |> schema.changeset(attributes)
    |> repo.update!([])
  end

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
      suffix = EctoResource.underscore_module_name(schema)
      resources = OptionParser.parse(suffix, options)

      Module.put_attribute(
        __MODULE__,
        :resources,
        {@repo, schema, EctoResource.resource_descriptions(resources)}
      )

      resources
      |> Map.keys()
      |> Enum.each(fn action ->
        action = Map.put(%{}, action, resources[action])

        case action do
          %{all: %{name: name, resource: resource}} ->
            @doc """
            Returns a list of all #{resource}.

            ## Examples
                iex> #{name}()
                [#{schema}, ...]
            """
            def unquote(name)(options \\ []),
              do: EctoResource.all(@repo, unquote(schema), options)

          %{change: %{name: name}} ->
            def unquote(name)(struct_or_changeset),
              do: EctoResource.change(unquote(schema), struct_or_changeset)

          %{create: %{name: name}} ->
            def unquote(name)(attributes),
              do: EctoResource.create(@repo, unquote(schema), attributes)

          %{create!: %{name: name}} ->
            def unquote(name)(attributes),
              do: EctoResource.create!(@repo, unquote(schema), attributes)

          %{delete: %{name: name}} ->
            def unquote(name)(struct_or_changeset),
              do: EctoResource.delete(@repo, struct_or_changeset)

          %{delete!: %{name: name}} ->
            def unquote(name)(struct_or_changeset),
              do: EctoResource.delete!(@repo, struct_or_changeset)

          %{get: %{name: name}} ->
            def unquote(name)(id, options \\ []),
              do: EctoResource.get(@repo, unquote(schema), id, options)

          %{get!: %{name: name}} ->
            def unquote(name)(id, options \\ []),
              do: EctoResource.get!(@repo, unquote(schema), id, options)

          %{update: %{name: name}} ->
            def unquote(name)(struct, changeset),
              do: EctoResource.update(@repo, unquote(schema), struct, changeset)

          %{update!: %{name: name}} ->
            def unquote(name)(struct, changeset),
              do: EctoResource.update!(@repo, unquote(schema), struct, changeset)

          _ ->
            nil
        end
      end)
    end
  end
end
