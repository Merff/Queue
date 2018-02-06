defmodule Queue.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :text, :text, null: false
      add :status, :integer, default: 0
      add :priority, :integer, :serial, null: false

      timestamps()
    end
  end
end
