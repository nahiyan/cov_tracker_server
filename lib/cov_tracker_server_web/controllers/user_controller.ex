defmodule CovTrackerServerWeb.UserController do
  use CovTrackerServerWeb, :controller
  alias CovTrackerServer.UserManager.User
  alias CovTrackerServer.UserManager
  alias CovTrackerServer.UserManager.Guardian

  def login(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "login.html", changeset: changeset)
  end

  def login_submit(conn, %{"username" => username, "password" => password}) do
    changeset = User.changeset(%User{}, %{})

    case UserManager.authenticate_user(username, password) do
      {:ok, user} ->
        conn
        |> put_flash(:success, "Login successful!")
        |> Guardian.Plug.sign_in(user)
        |> render("login.html", changeset: changeset)

      {:error, reason} ->
        conn
        |> put_flash(:error, to_string(reason))
        |> render("login.html", changeset: changeset)
    end
  end

  def register(conn, _params) do
    changeset = User.changeset(%User{}, %{})

    render(conn, "register.html", changeset: changeset)
  end

  def register_submit(conn, params) do
    case UserManager.create_user(params) do
      {:ok, _} ->
        changeset = User.changeset(%User{}, %{})

        conn
        |> put_flash(:success, "Registration successful!")
        |> render("register.html", changeset: changeset)

      {:error, changeset} ->
        conn
        |> put_flash(:error, "There are errors with the input.")
        |> render("register.html", changeset: changeset)
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  def api_login(conn, %{"username" => username, "password" => password}) do
    case UserManager.authenticate_user(username, password) do
      {:ok, user} ->
        with {:ok, token, _} <- Guardian.encode_and_sign(user) do
          render(conn, "login.json", token: token)
        else
          _ ->
            render(conn, "login.json", error: "Failed to generate token.")
        end

      {:error, reason} ->
        render(conn, "login.json", error: reason)
    end
  end

  # def test_token(conn, %{"token" => token}) do
  #   with(
  #     {:ok, claims} <- Guardian.decode_and_verify(token),
  #     {:ok, user} <- Guardian.resource_from_claims(claims)
  #   ) do
  #     render(conn, "test.json", token: user.username)
  #   else
  #     _ ->
  #       render(conn, "test.json")
  #   end
  # end
end
