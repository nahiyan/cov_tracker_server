defmodule CovTrackerServer.Aux do
  import Phoenix.HTML, only: [html_escape: 1, raw: 1, safe_to_string: 1]

  def random(low, high) do
    :rand.uniform() * (high - low) + low
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
end
