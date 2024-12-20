defmodule CameraManager.Repo.Migrations.CreateCameras do
  use Ecto.Migration

  def change do
    create table(:cameras) do
      add :brand, :string, null: false
      add :status, :string, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:cameras, [:user_id])
  end
end
