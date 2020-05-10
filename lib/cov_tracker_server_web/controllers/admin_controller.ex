defmodule CovTrackerServerWeb.AdminController do
  use CovTrackerServerWeb, :controller
  # alias CovTrackerServer.Locations
  alias CovTrackerServer.Repo
  import Ecto.Query, only: [from: 2]
  import NaiveDateTime, only: [utc_now: 0, add: 3]

  def index(conn, _params) do
    # Current threshold = 10 minutes
    threshold = 10 * 60
    threshold_time = add(utc_now(), -threshold, :second)

    query =
      from u in "users",
        left_join: l in "locations",
        on: u.id == l.user_id,
        distinct: u.id,
        select: {u.id, l.timestamp, l.longitude, l.latitude},
        order_by: [desc: l.timestamp],
        where: l.timestamp >= ^threshold_time

    locations = Repo.all(query)

    center_location =
      with {:ok, location} <- Enum.fetch(locations, 0) do
        location
      else
        _ ->
          nil
      end

    conn
    |> put_layout("admin.html")
    |> render("index.html", locations: locations, center_location: center_location)
  end
end
