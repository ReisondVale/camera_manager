defmodule CameraManager.Accounts.User do
  @moduledoc """
  The `User` schema represents a user within the system.

  ## Fields
  - `name` (string): The name of the user.
  - `status` (string): The status of the user, which can be either `"active"` or `"inactive"`. Defaults to `"active"`.
  - `inactive_at` (utc_datetime): The timestamp of when the user was marked as "inactive". This is set automatically when the status is changed to `"inactive"`.
  - `cameras` (has_many association): A user can have many cameras.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias CameraManager.Cameras.Camera

  @status_values ["active", "inactive"]

  @derive {Jason.Encoder, only: [:id, :name, :inserted_at, :updated_at]}
  schema "users" do
    field :name, :string
    field :status, :string, default: "active"
    field :inactive_at, :utc_datetime
    has_many :cameras, Camera

    timestamps(type: :utc_datetime)
  end

  @spec changeset(%CameraManager.Accounts.User{}, map()) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :status])
    |> validate_required([:name, :status])
    |> validate_inclusion(:status, @status_values,
      message: "must be one of: #{@status_values |> Enum.join(", ")}"
    )
    |> unique_constraint(:name)
    |> put_inactive_at()
  end

  defp put_inactive_at(changeset) do
    case get_change(changeset, :status) do
      "inactive" ->
        put_change(changeset, :inactive_at, DateTime.truncate(DateTime.utc_now(), :second))

      _ ->
        changeset
    end
  end
end
