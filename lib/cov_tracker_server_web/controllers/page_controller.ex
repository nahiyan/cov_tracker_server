defmodule CovTrackerServerWeb.PageController do
  use CovTrackerServerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
