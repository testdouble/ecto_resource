defmodule EctoResource.TestRepo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add(:first_name, :string, null: false)
      add(:last_name, :string, null: false)
      add(:age, :integer, null: false)
    end
  end
end
