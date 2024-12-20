defmodule CameraManager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :status, :string, null: false
      add :inactive_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:name])
  end
end
