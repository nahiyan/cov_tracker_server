defmodule CovTrackerServerWeb.Router do
  use CovTrackerServerWeb, :router

  # Our pipeline implements "maybe" authenticated. We'll use the `:ensure_auth` below for when we need to make sure someone is logged in.
  pipeline :auth do
    plug CovTrackerServer.UserManager.Pipeline
  end

  # We use ensure_auth to fail if there is no one logged in
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # API
  scope "/api", CovTrackerServerWeb do
    pipe_through [:api]

    get "/test", UserController, :test
    get "/test_token/:token", UserController, :test_token
  end

  # Maybe logged in routes
  scope "/", CovTrackerServerWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index

    # User login/registration
    get "/login", UserController, :login
    post "/login", UserController, :login_submit
    get "/logout", UserController, :logout

    get "/register", UserController, :register
    post "/register", UserController, :register_submit
  end

  # Definitely logged in scope
  scope "/", CovTrackerServerWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/dashboard", DashboardController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", CovTrackerServerWeb do
  #   pipe_through :api
  # end
end
