defmodule EctoResource.ResourceFunctions do
  @moduledoc false
  import Ecto.Query

  @spec change(module, Ecto.Schema.t()) :: Ecto.Changeset.t()
  def change(schema, changable) do
    changable
    |> schema.changeset(%{})
  end

  def create(repo, schema, attributes) do
    schema
    |> struct()
    |> schema.changeset(attributes)
    |> repo.insert([])
  end

  @spec create!(Ecto.Repo.t(), module, map()) :: Ecto.Schema.t()
  def create!(repo, schema, attributes) do
    schema
    |> struct()
    |> schema.changeset(attributes)
    |> repo.insert!([])
  end

  @spec delete(Ecto.Repo.t(), Ecto.Schema.t()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete(repo, deletable) do
    deletable
    |> repo.delete([])
  end

  @spec delete!(Ecto.Repo.t(), Ecto.Schema.t()) :: Ecto.Schema.t()
  def delete!(repo, deletable) do
    deletable
    |> repo.delete!([])
  end

  @spec get(Ecto.Repo.t(), module, term(), term()) :: Ecto.Schema.t() | nil
  def get(repo, schema, id, options \\ []) do
    preloads = Keyword.get(options, :preloads, [])

    schema
    |> preload(^preloads)
    |> repo.get(id, [])
  end

  @spec get!(Ecto.Repo.t(), module, term(), term()) :: Ecto.Schema.t()
  def get!(repo, schema, id, options \\ []) do
    preloads = Keyword.get(options, :preloads, [])

    schema
    |> preload(^preloads)
    |> repo.get!(id, [])
  end

  @spec all(Ecto.Repo.t(), module, term()) :: list(Ecto.Schema.t())
  def all(repo, schema, options \\ []) do
    preloads = Keyword.get(options, :preloads, [])
    order_by = Keyword.get(options, :order_by, [])

    schema
    |> preload(^preloads)
    |> order_by(^order_by)
    |> repo.all([])
  end

  def update(repo, schema, updateable, attributes) do
    updateable
    |> schema.changeset(attributes)
    |> repo.update([])
  end

  @spec update!(Ecto.Repo.t(), module, Ecto.Schema.t(), map()) :: Ecto.Schema.t()
  def update!(repo, schema, updateable, attributes) do
    updateable
    |> schema.changeset(attributes)
    |> repo.update!([])
  end
end
