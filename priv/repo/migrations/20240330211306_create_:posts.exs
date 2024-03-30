defmodule EctoCooler.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :text, null: false
      
      timestamps()
    end

  end
end
