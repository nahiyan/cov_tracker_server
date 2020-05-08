defmodule CovTrackerServerWeb.UserView do
  use CovTrackerServerWeb, :view

  def render("test.json", params) do
    with %{token: token} <- params.conn.assigns do
      %{fuck: token}
    else
      _ ->
        %{fuck: "me"}
    end
  end
end
