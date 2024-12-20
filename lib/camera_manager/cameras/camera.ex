defmodule CameraManager.Cameras.Camera do
  @moduledoc """
  Represents the structure of a camera associated with a user in the system.

  ## Fields
    - `status`: The status of the camera, which can be "active" or "inactive".
    - `brand`: The brand of the camera, which must be one of the following: "Intelbras", "Hikvision", "Giga", or "Vivotek".
    - `user_id`: A reference to the user associated with the camera.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @status_values ["active", "inactive"]
  @brand_values ["Intelbras", "Hikvision", "Giga", "Vivotek"]

  @derive {Jason.Encoder, only: [:id, :status, :brand, :user_id, :inserted_at, :updated_at]}
  schema "cameras" do
    field :status, :string
    field :brand, :string
    belongs_to :user, CameraManager.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @spec changeset(%CameraManager.Cameras.Camera{}, map()) :: Ecto.Changeset.t()
  def changeset(camera, attrs) do
    camera
    |> cast(attrs, [:brand, :status, :user_id])
    |> validate_required([:brand, :status, :user_id])
    |> validate_inclusion(:status, @status_values,
      message: "must be one of: #{@status_values |> Enum.join(", ")}"
    )
    |> validate_inclusion(:brand, @brand_values,
      message: "must be one of: #{@brand_values |> Enum.join(", ")}"
    )
  end
end
