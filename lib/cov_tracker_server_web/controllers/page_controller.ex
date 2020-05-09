defmodule CovTrackerServerWeb.PageController do
  use CovTrackerServerWeb, :controller
  alias CovTrackerServer.UserManager.Guardian

  def index(conn, _params) do
    authenticated? =
      if conn |> Guardian.Plug.authenticated?() do
        true
      else
        false
      end

    isAdmin? =
      if authenticated? do
        with nil <- Guardian.Plug.current_resource(conn) do
          false
        else
          user ->
            if user.type == 1 do
              true
            else
              false
            end
        end
      else
        false
      end

    render(conn, "index.html", authenticated: authenticated?, is_admin: isAdmin?)
  end
end
