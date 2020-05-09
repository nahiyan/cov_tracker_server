defmodule CovTrackerServerWeb.RoomChannel do
  use Phoenix.Channel
  alias CovTrackerServer.Repo
  alias CovTrackerServer.Locations.Location
  alias CovTrackerServer.UserManager.Guardian

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in(
        "location_update",
        %{
          "altitude" => altitude,
          "longitude" => longitude,
          "latitude" => latitude,
          "timestamp" => timestamp,
          "token" => token
        },
        socket
      ) do
    with {:ok, user, _} <- Guardian.resource_from_token(token) do
      Repo.insert(%Location{
        altitude: altitude,
        longitude: longitude,
        latitude: latitude,
        timestamp: timestamp,
        user_id: user.id
      })

      {:reply, {:ok, %{}}, socket}
    else
      _ ->
        {:reply, {:error, %{"reason" => "Unauthorized"}}, socket}
    end
  end

  def handle_in(
        "location_update",
        %{
          "test" => true,
          "token" => token
        },
        socket
      ) do
    with {:ok, _, _} <- Guardian.resource_from_token(token) do
      {:reply, {:ok, %{}}, socket}
    else
      _ ->
        {:reply, {:error, %{"reason" => "Unauthorized"}}, socket}
    end
  end
end
