defmodule EctoResource.ResourceFunctions do
  @moduledoc """
  This module represents the generic CRUD functionality that is boilerplate within
  Phoenix context files. These are wrapper functions around basic Ecto.Repo
  functions for CRUD operations.
  """
  import Ecto.Query

  @doc """
  Creates a changeset for a given Schema

      iex> change(%User{email: "user@example.com"}, %{email: "updated-email@example.com"})

      #Ecto.Changeset<
        action: nil,
        changes: %{},
        errors: [],
        data: #User<>,
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
end
