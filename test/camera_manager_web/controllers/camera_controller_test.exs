defmodule CameraManagerWeb.CameraControllerTest do
  use CameraManagerWeb.ConnCase, async: true

  alias CameraManager.Repo
  alias CameraManager.Accounts.User
  alias CameraManager.Cameras.Camera

  describe "index" do
    test "successfully returns active and inactive users", %{conn: conn} do
      %{id: user_id_active} = Repo.insert!(%User{name: "User1", status: "active"})

      Repo.insert!(%Camera{
        status: "active",
        brand: "Hikvision",
        user_id: user_id_active
      })

      %{id: user_id_inactive} = Repo.insert!(%User{name: "User2", status: "active"})

      Repo.insert!(%Camera{
        status: "active",
        brand: "Hikvision",
        user_id: user_id_inactive
      })

      User
      |> Repo.get!(user_id_inactive)
      |> User.changeset(%{status: "inactive"})
      |> Repo.update()

      conn = get(conn, ~p"/api/cameras")

      response = json_response(conn, 200)

      assert %{"users" => users} = response

      assert [
               %{
                 "name" => "User1",
                 "cameras" => [%{"brand" => "Hikvision", "status" => "active"}]
               },
               %{
                 "name" => "User2",
                 "inactive_at" => inactive_at
               }
             ] = users

      assert not is_nil(inactive_at)
    end

    test "Successfully returns users with camera filters", %{conn: conn} do
      %{id: user_id1} = Repo.insert!(%User{name: "User1", status: "active"})

      Repo.insert!(%Camera{
        status: "active",
        brand: "Hikvision",
        user_id: user_id1
      })

      %{id: user_id2} = Repo.insert!(%User{name: "User2", status: "active"})

      Repo.insert!(%Camera{
        status: "active",
        brand: "Intelbras",
        user_id: user_id2
      })

      conn = get(conn, ~p"/api/cameras?brand=Hikvision")

      response = json_response(conn, 200)

      assert %{"users" => users} = response

      assert [
               %{
                 "name" => "User1",
                 "cameras" => [%{"brand" => "Hikvision", "status" => "active"}]
               }
             ] = users
    end

    test "successfully returns an empty list when there are no users in database", %{conn: conn} do
      conn = get(conn, ~p"/api/cameras")

      response = json_response(conn, 200)

      assert %{"users" => users} = response

      assert Enum.empty?(users)
    end

    test "successfully returns an empty list when the brand passed to the filter does not exist",
         %{conn: conn} do
      %{id: user_id1} = Repo.insert!(%User{name: "User1", status: "active"})

      Repo.insert!(%Camera{
        status: "active",
        brand: "Hikvision",
        user_id: user_id1
      })

      %{id: user_id2} = Repo.insert!(%User{name: "User2", status: "active"})

      Repo.insert!(%Camera{
        status: "active",
        brand: "Intelbras",
        user_id: user_id2
      })

      conn = get(conn, ~p"/api/cameras?brand=Sony")

      response = json_response(conn, 200)

      assert %{"users" => users} = response

      assert Enum.empty?(users)
    end
  end
end
