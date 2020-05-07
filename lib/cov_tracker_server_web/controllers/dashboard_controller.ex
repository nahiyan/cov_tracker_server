defmodule CovTrackerServerWeb.DashboardController do
  use CovTrackerServerWeb, :controller

  def index(conn, _params) do
    # case conn |> Guardian.Plug.current_claims() do
    #   nil ->
    #     render(conn, "index.html")
    #   claims ->
    #     case UserManager.Guardian.resource_from_claims(claims) do
    #       {:ok, user} ->
    #         render(conn, "index.html", user: user)

    #     end
    # end
    render(conn, "index.html")
  end
end
