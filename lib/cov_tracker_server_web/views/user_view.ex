defmodule CovTrackerServerWeb.UserView do
  use CovTrackerServerWeb, :view

  def render("login.json", params) do
    case params.conn.assigns do
      %{token: token} ->
        %{"status" => "ok", "token" => token}

      %{error: error} ->
        %{"status" => "error", "reason" => error}
    end
  end
end
