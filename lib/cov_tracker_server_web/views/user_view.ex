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

  def render("register.json", params) do
    case params.conn.assigns do
      %{status: :ok, token: token} ->
        %{"status" => "ok", "token" => token}

      %{status: :error, reason: reason} ->
        %{"status" => "error", "reason" => reason}

      %{status: :error, changeset: changeset} ->
        reasons =
          Enum.map(changeset.errors, fn {key, {reason, _}} ->
            case key do
              :username ->
                %{"key" => "NID number" <> " " <> reason}

              :phone_number ->
                %{"key" => "Phone number" <> " " <> reason}

              :password_confirmation ->
                %{"key" => reason |> String.capitalize()}

              _ ->
                %{"key" => (to_string(key) |> String.capitalize()) <> " " <> reason}
            end
          end)

        %{"status" => "error", "reasons" => reasons}
    end
  end

  def tr(content) do
    tr_inner_html =
      content
      |> Enum.map(fn item ->
        "<td>" <> (html_escape(item) |> safe_to_string()) <> "</td>"
      end)
      |> Enum.reduce("<tr>", fn x, acc -> acc <> x end)

    (tr_inner_html <> "</tr>") |> raw()
  end

  def label_(label_code) do
    class =
      case label_code do
        0 ->
          "gray"

        1 ->
          "red"

        2 ->
          "orange"

        3 ->
          "yellow"

        4 ->
          "pink"

        5 ->
          "black"
      end

    ("<span class='label " <> class <> "'></span>") |> raw()
  end
end
