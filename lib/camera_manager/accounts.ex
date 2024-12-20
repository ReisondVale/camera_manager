defmodule CameraManager.Accounts do
  @moduledoc """
  A module for handling user-related data and operations.

  Provides functions to retrieve users with cameras, optionally filtered by camera brand.
  Includes functionalities to fetch users with a specific camera brand.

  Functions:
    - list_users_with_cameras/1: Lists all users with active cameras, optionally filtered by camera brand.
    - fetch_users_with_brand/1: Fetches users who have cameras of a specific brand.
  """
  import Ecto.Query

  alias CameraManager.Repo
  alias CameraManager.Accounts.User

  @spec list_users_with_cameras(String.t() | nil) :: [Ecto.Schema.t() | term()]
  def list_users_with_cameras(brand_filter \\ nil) do
    query =
      from u in User,
        left_join: c in assoc(u, :cameras),
        preload: [cameras: c]

    query =
      if brand_filter do
        from [u, c] in query,
          where: c.brand == ^brand_filter and c.status == "active"
      else
        from [u, c] in query,
          where: c.status == "active"
      end

    Repo.all(query)
  end

  @spec fetch_users_with_brand(String.t()) :: [Ecto.Schema.t() | term()]
  def fetch_users_with_brand(brand) do
    query =
      from u in User,
        join: c in assoc(u, :cameras),
        where: c.brand == ^brand,
        distinct: u.id,
        select: u

    Repo.all(query)
  end
end
