defmodule CovTrackerServerWeb.RoomChannel do
  use Phoenix.Channel
  alias CovTrackerServer.Repo
  alias CovTrackerServer.Location

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
          "timestamp" => timestamp
        },
        socket
      ) do
    Repo.insert(%Location{
      altitude: altitude,
      longitude: longitude,
      latitude: latitude,
      timestamp: timestamp,
      user_id: 0
    })

    {:noreply, socket}
  end
end
