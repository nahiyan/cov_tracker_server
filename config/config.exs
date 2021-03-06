# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cov_tracker_server,
  ecto_repos: [CovTrackerServer.Repo]

# Configures the endpoint
config :cov_tracker_server, CovTrackerServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tCeMuM5LHNVdvJrCz/e0pXrRh1ggKstHQ+wHU5f/4lTgDUqnUZvjfAQkOA4Wy7bK",
  render_errors: [view: CovTrackerServerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CovTrackerServer.PubSub, adapter: Phoenix.PubSub.PG2]

config :cov_tracker_server, CovTrackerServer.UserManager.Guardian,
  issuer: "cov_tracker_server",
  secret_key: "w/xAqvjpjHeYUwv/BZQOO+UsMsOPANIe7+CXrZmvr0XZbGHo5fWE2tOBl43CQ1DD"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
