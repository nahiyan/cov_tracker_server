defmodule CovTrackerServerWeb.UserView do
  use CovTrackerServerWeb, :view

  def render("login.json", params) do
    case params.conn.assigns do
      %{token: token} ->
        %{"token" => token}

      %{error: error} ->
        %{"error" => error}
    end
  end
end
