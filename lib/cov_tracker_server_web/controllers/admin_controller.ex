defmodule CovTrackerServerWeb.AdminController do
  use CovTrackerServerWeb, :controller

  def index(conn, _params) do
    conn
    |> put_layout("admin.html")
    |> render("index.html")
  end
end
