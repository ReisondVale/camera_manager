# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CameraManager.Repo.insert!(%CameraManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias CameraManager.Accounts.User
alias CameraManager.Cameras.Camera
alias CameraManager.Repo

brands = ["Intelbras", "Hikvision", "Giga", "Vivotek"]

users =
  for i <- 1..1_000 do
    %{
      name: "User_#{i}",
      status: "active",
      inserted_at: DateTime.utc_now() |> DateTime.truncate(:second),
      updated_at: DateTime.utc_now() |> DateTime.truncate(:second)
    }
  end

{_count, result} = Repo.insert_all(User, users, returning: [:id])

user_ids = Enum.map(result, & &1.id)

cameras =
  for user_id <- user_ids, j <- 1..50 do
    %{
      brand: Enum.random(brands),
      user_id: user_id,
      status:
        if j == 1 do
          "active"
        else
          Enum.random(["active", "inactive"])
        end,
      inserted_at: DateTime.utc_now() |> DateTime.truncate(:second),
      updated_at: DateTime.utc_now() |> DateTime.truncate(:second)
    }
  end

Enum.chunk_every(cameras, 5_000)
|> Enum.each(fn cameras_chunk ->
  Repo.insert_all(Camera, cameras_chunk)
end)
