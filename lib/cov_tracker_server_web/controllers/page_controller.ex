defmodule CovTrackerServerWeb.PageController do
  use CovTrackerServerWeb, :controller

  def index(conn, _params) do
    authenticated =
      if conn |> Guardian.Plug.authenticated?() do
        true
      else
        false
      end

    render(conn, "index.html", authenticated: authenticated)
  end
end
