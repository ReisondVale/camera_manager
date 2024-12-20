defmodule CameraManagerWeb.NotifyUsersController do
  @moduledoc """
  The `NotifyUsersController` handles notifying users with specific camera brands.

  ## Actions

  - `notify_users/2`:
    - Identifies users who own cameras of the "Hikvision" brand.
    - Sends an email notification to these users using the `Utils.send_email/1` function.
    - Returns a JSON response with one of the following messages:
      - `"No users with Hikvision cameras found."` if no matching users are found.
      - `"Emails sent successfully to users with Hikvision cameras."` if emails are sent.
  """

  use CameraManagerWeb, :controller

  alias CameraManager.Accounts
  alias CameraManager.Utils

  @spec notify_users(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def notify_users(conn, _params) do
    users_with_hikvision_cameras = Accounts.fetch_users_with_brand("Hikvision")

    if Enum.empty?(users_with_hikvision_cameras) do
      json(conn, %{message: "No users with Hikvision cameras found."})
    else
      Enum.each(users_with_hikvision_cameras, &Utils.send_email/1)

      json(conn, %{message: "Emails sent successfully to users with Hikvision cameras."})
    end
  end
end
