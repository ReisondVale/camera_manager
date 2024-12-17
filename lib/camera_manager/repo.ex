defmodule CameraManager.Repo do
  use Ecto.Repo,
    otp_app: :camera_manager,
    adapter: Ecto.Adapters.Postgres
end
