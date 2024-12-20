defmodule CameraManagerWeb.NotifyUsersControllerTest do
  use CameraManagerWeb.ConnCase, async: true

  alias CameraManager.Accounts
  alias CameraManager.Repo
  alias CameraManager.Accounts.User
  alias CameraManager.Cameras.Camera

  describe "notify_users" do
    test "responds with no users message when no users have Hikvision cameras", %{conn: conn} do
      Accounts.fetch_users_with_brand("Hikvision")
      |> Enum.each(&Repo.delete/1)

      conn = post(conn, ~p"/api/notify-users")

      assert json_response(conn, 200) == %{
               "message" => "No users with Hikvision cameras found."
             }
    end

    test "responds with success message when emails are sent to users with Hikvision cameras", %{
      conn: conn
    } do
      %{id: user_id} = Repo.insert!(%User{name: "User123"})

      Repo.insert!(%Camera{
        status: "active",
        brand: "Hikvision",
        user_id: user_id
      })

      conn = post(conn, ~p"/api/notify-users")

      assert json_response(conn, 200) == %{
               "message" => "Emails sent successfully to users with Hikvision cameras."
             }
    end
  end
end
