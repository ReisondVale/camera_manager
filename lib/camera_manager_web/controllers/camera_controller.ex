defmodule CameraManagerWeb.CameraController do
  @moduledoc """
  The `CameraController` is responsible for handling requests related to users and their cameras.

  ## Actions

  - `index/2`:
    - Fetches and returns a list of users and their associated cameras in JSON format.
    - If a `brand` parameter is provided, the response is filtered to include only cameras of the specified brand.
    - Users with `active` status include their camera details.
    - Users with `inactive` status include their name and `inactive_at` timestamp.
  """
  use CameraManagerWeb, :controller

  alias CameraManager.Accounts

  def index(conn, %{"brand" => brand_filter}) do
    users = Accounts.list_users_with_cameras(brand_filter)
    render_json(conn, users)
  end

  def index(conn, _params) do
    users = Accounts.list_users_with_cameras()
    render_json(conn, users)
  end

  defp render_json(conn, users) do
    formatted_users =
      Enum.map(users, fn user ->
        case user.status do
          "active" ->
            %{
              name: user.name,
              cameras:
                Enum.map(user.cameras, fn camera ->
                  %{status: camera.status, brand: camera.brand}
                end)
            }

          "inactive" ->
            %{
              name: user.name,
              inactive_at: user.inactive_at
            }
        end
      end)

    conn
    |> put_status(:ok)
    |> put_resp_content_type("application/json")
    |> json(%{users: formatted_users})
  end
end
