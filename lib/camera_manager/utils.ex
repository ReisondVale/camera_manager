defmodule CameraManager.Utils do
  @moduledoc """
  A module for utility functions.

  This module provides a function to send an email notification to a user.
  The email contains a notification message specifically for users with Hikvision cameras.

  Functions:
    - send_email/1: Sends an email notification to the specified user.
  """
  import Swoosh.Email

  alias CameraManager.Mailer

  @spec send_email(map()) :: {:ok, term()} | {:error, any()}
  def send_email(user) do
    email =
      new()
      |> to({user.name, "#{user.name}@example.com"})
      |> from({"CameraManager", "no-reply@cameramanager.com"})
      |> subject("Notification for Hikvision Camera Users")
      |> html_body(
        "<h1>Hello #{user.name},</h1><p>This is a notification for your Hikvision cameras.</p>"
      )
      |> text_body("Hello #{user.name},\n\nThis is a notification for your Hikvision cameras.")

    Mailer.deliver(email)
  end
end
