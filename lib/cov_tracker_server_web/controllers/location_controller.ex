defmodule CovTrackerServerWeb.LocationController do
  use CovTrackerServerWeb, :controller
  alias CovTrackerServer.Locations
  import Ecto.Query
  alias CovTrackerServer.Repo

  def list(conn, _) do
    query =
      from(l in "locations",
        left_join: u in "users",
        on: u.id == l.user_id,
        order_by: [asc: l.id],
        select: %{
          id: l.id,
          user_nid_number: u.username,
          timestamp: l.timestamp,
          latitude: l.latitude,
          longitude: l.longitude
        }
      )

    locations = Repo.all(query)

    conn
    |> put_layout("admin.html")
    |> render("list.html", locations: locations)
  end
end
