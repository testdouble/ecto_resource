defmodule EctoResource.TestSchema.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:age, :integer)
  end

  @doc false
  def changeset(person, attrs) do
    cast(person, attrs, [:first_name, :last_name, :age])
  end
end
