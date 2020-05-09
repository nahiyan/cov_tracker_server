defmodule CovTrackerServerWeb.Plugs do
  alias CovTrackerServer.UserManager.Guardian
  import Plug.Conn, only: [halt: 1]
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]

  def disallow(conn) do
    conn
    |> put_flash(:error, "You're not authorized to access this page.")
    |> redirect(to: "/")
    |> halt()
  end

  def ensure_admin(conn, _) do
    with nil <- Guardian.Plug.current_resource(conn) do
      disallow(conn)
    else
      user ->
        if user.type == 1 do
          conn
        else
          disallow(conn)
        end
    end
  end
end
