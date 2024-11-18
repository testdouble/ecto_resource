defmodule EctoResource.ResourceFunctions do
  @moduledoc false
  import Ecto.Query

  @spec change(module, Ecto.Schema.t(), map() | Keyword.t()) :: Ecto.Changeset.t()

  def change(schema, changeable, changes) when is_map(changes) do
    schema.changeset(changeable, changes)
  end

  def change(schema, changeable, changes) when is_list(changes) do
    change(schema, changeable, Enum.into(changes, %{}))
  end

  @spec changeset(module()) :: Ecto.Changeset.t()
  def changeset(schema) do
    schema
    |> struct()
    |> schema.changeset(%{})
  end

  @spec create(Ecto.Repo.t(), module, map() | Keyword.t()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  def create(repo, schema, attributes) when is_map(attributes) do
    schema
    |> struct()
    |> schema.changeset(attributes)
    |> repo.insert([])
  end

  def create(repo, schema, attributes) when is_list(attributes) do
    create(repo, schema, Enum.into(attributes, %{}))
  end

  @spec create!(Ecto.Repo.t(), module, map() | Keyword.t()) :: Ecto.Schema.t()

  def create!(repo, schema, attributes) when is_map(attributes) do
    schema
    |> struct()
    |> schema.changeset(attributes)
    |> repo.insert!([])
  end

  def create!(repo, schema, attributes) when is_list(attributes) do
    create!(repo, schema, Enum.into(attributes, %{}))
  end

  @spec delete(Ecto.Repo.t(), Ecto.Schema.t()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  def delete(repo, deletable) do
    repo.delete(deletable, [])
  end

  @spec delete!(Ecto.Repo.t(), Ecto.Schema.t()) :: Ecto.Schema.t()

  def delete!(repo, deletable) do
    repo.delete!(deletable, [])
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

  @spec get_by(Ecto.Repo.t(), Ecto.Queryable.t(), Keyword.t() | map(), Keyword.t()) ::
          Ecto.Schema.t() | nil

  def get_by(repo, schema, attributes, options \\ []) do
    preloads = Keyword.get(options, :preloads, [])

    schema
    |> preload(^preloads)
    |> repo.get_by(attributes, options)
  end

  @spec get_by!(Ecto.Repo.t(), Ecto.Queryable.t(), Keyword.t() | map(), Keyword.t()) ::
          Ecto.Schema.t()

  def get_by!(repo, schema, attributes, options \\ []) do
    preloads = Keyword.get(options, :preloads, [])

    schema
    |> preload(^preloads)
    |> repo.get_by!(attributes, options)
  end

  @spec all(Ecto.Repo.t(), module, term()) :: list(Ecto.Schema.t())

  def all(repo, schema, options \\ []) do
    options
    |> Keyword.take([:preloads, :order_by, :where, :limit, :offset])
    |> Enum.reduce(schema, fn
      {:preloads, preloads}, query -> preload(query, ^preloads)
      {:order_by, order_by}, query -> order_by(query, ^order_by)
      {:where, where}, query -> where(query, ^where)
      {:limit, limit}, query -> limit(query, ^limit)
      {:offset, offset}, query -> offset(query, ^offset)
      _, query -> query
    end)
    |> repo.all([])
  end

  @spec update(Ecto.Repo.t(), module, Ecto.Schema.t(), map() | Keyword.t()) ::
          {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}

  def update(repo, schema, updateable, attributes) when is_map(attributes) do
    updateable
    |> schema.changeset(attributes)
    |> repo.update([])
  end

  def update(repo, schema, updateable, attributes) when is_list(attributes) do
    update(repo, schema, updateable, Enum.into(attributes, %{}))
  end

  @spec update!(Ecto.Repo.t(), module, Ecto.Schema.t(), map() | Keyword.t()) :: Ecto.Schema.t()

  def update!(repo, schema, updateable, attributes) when is_map(attributes) do
    updateable
    |> schema.changeset(attributes)
    |> repo.update!([])
  end

  def update!(repo, schema, updateable, attributes) when is_list(attributes) do
    update!(repo, schema, updateable, Enum.into(attributes, %{}))
  end
end
