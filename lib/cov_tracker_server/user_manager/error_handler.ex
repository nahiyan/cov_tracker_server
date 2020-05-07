defmodule CovTrackerServer.UserManager.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts) do
    body = "You're not allowed to access this page."

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, body)
  end
end
