defmodule CovTrackerServer.Repo do
  use Ecto.Repo,
    otp_app: :cov_tracker_server,
    adapter: Ecto.Adapters.Postgres
end
