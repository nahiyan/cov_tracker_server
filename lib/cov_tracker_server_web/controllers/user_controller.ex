defmodule CovTrackerServerWeb.UserController do
  use CovTrackerServerWeb, :controller
  alias CovTrackerServer.UserManager.User
  alias CovTrackerServer.UserManager
  alias CovTrackerServer.UserManager.Guardian
  alias CovTrackerServer.Repo
  import Ecto.Query, only: [from: 2, or_where: 3, where: 3]
  import NaiveDateTime, only: [add: 3]
  alias Geocalc

  def list(conn, _) do
    # Thresholds
    # 10m
    threshold_radius = 10
    # 5 minutes
    threshold_time = 5 * 60

    # Red locations
    red_locations_query =
      from i in "infections",
        left_join: u in "users",
        on: i.user_id == u.id,
        left_join: l in "locations",
        on: l.user_id == u.id,
        select: %{
          latitude: l.latitude,
          longitude: l.longitude,
          timestamp: l.timestamp
        },
        where: not is_nil(l.id)

    red_locations = Repo.all(red_locations_query)

    # Orange users
    red_user_ids = Repo.all(from i in "infections", select: i.user_id)

    oranges_query =
      from l in "locations",
        left_join: u in "users",
        on: l.user_id == u.id,
        select: %{
          user_id: u.id,
          latitude: l.latitude,
          longitude: l.longitude,
          timestamp: l.timestamp
        }

    oranges_query_with_wheres =
      red_locations
      |> Enum.map(fn %{latitude: latitude, longitude: longitude, timestamp: timestamp} ->
        %{
          geo_range:
            Geocalc.bounding_box(
              [Decimal.to_float(latitude), Decimal.to_float(longitude)],
              threshold_radius
            ),
          timestamp_range: [
            add(timestamp, -threshold_time, :second),
            add(timestamp, threshold_time, :second)
          ]
        }
      end)
      |> Enum.reduce(oranges_query, fn
        %{
          geo_range: [[lat_min, lon_min], [lat_max, lon_max]],
          timestamp_range: [ts_min, ts_max]
        },
        query ->
          or_where(
            query,
            [l],
            l.latitude >= ^lat_min and l.latitude <= ^lat_max and l.longitude >= ^lon_min and
              l.longitude <= ^lon_max and l.timestamp >= ^ts_min and l.timestamp <= ^ts_max
          )
      end)

    orange_users = Repo.all(oranges_query_with_wheres)

    # Yellow users
    orange_user_ids =
      orange_users
      |> Enum.map(fn %{user_id: user_id} ->
        user_id
      end)

    yellow_query =
      from l in "locations",
        left_join: u in "users",
        on: l.user_id == u.id,
        select: u.id,
        distinct: u.id

    # where: u.id not in ^orange_user_ids

    yellow_query_with_wheres =
      orange_users
      |> Enum.map(fn %{latitude: latitude, longitude: longitude, timestamp: timestamp} ->
        %{
          geo_range:
            Geocalc.bounding_box(
              [Decimal.to_float(latitude), Decimal.to_float(longitude)],
              threshold_radius
            ),
          timestamp_range: [
            add(timestamp, -threshold_time, :second),
            add(timestamp, threshold_time, :second)
          ]
        }
      end)
      |> Enum.reduce(yellow_query, fn
        %{
          geo_range: [[lat_min, lon_min], [lat_max, lon_max]],
          timestamp_range: [ts_min, ts_max]
        },
        query ->
          or_where(
            query,
            [l],
            l.latitude >= ^lat_min and l.latitude <= ^lat_max and l.longitude >= ^lon_min and
              l.longitude <= ^lon_max and l.timestamp >= ^ts_min and l.timestamp <= ^ts_max
          )
      end)

    yellow_users = Repo.all(yellow_query_with_wheres)

    # Reset labels of everyone
    all_users = Repo.all(from(u in User, select: u.id))
    update_labels_query = from(u in User, update: [set: [label: 0]], where: u.id in ^all_users)
    Repo.update_all(update_labels_query, [])

    # Update labels of yellow users
    update_labels_query = from(u in User, update: [set: [label: 3]], where: u.id in ^yellow_users)
    Repo.update_all(update_labels_query, [])

    # Update labels of orange users
    update_labels_query =
      from(u in User, update: [set: [label: 2]], where: u.id in ^orange_user_ids)

    Repo.update_all(update_labels_query, [])

    # Update labels of red users
    update_labels_query = from(u in User, update: [set: [label: 1]], where: u.id in ^red_user_ids)
    Repo.update_all(update_labels_query, [])

    users = UserManager.list_users()

    conn
    |> put_layout("admin.html")
    |> render("list.html", users: users)
  end

  def login(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "login.html", changeset: changeset)
  end

  def login_submit(conn, %{"username" => username, "password" => password}) do
    case UserManager.authenticate_user(username, password) do
      {:ok, user} ->
        conn
        |> put_flash(:success, "Login successful!")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/")

      {:error, reason} ->
        changeset = User.changeset(%User{}, %{})

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
        # changeset = User.changeset(%User{}, %{})

        conn
        |> put_flash(:success, "Registration successful!")
        |> redirect(to: "/")

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

  def infections(conn, _params) do
    infections = UserManager.list_infected_users()

    conn
    |> put_layout("admin.html")
    |> render("infections.html", infections: infections)
  end

  def api_login(conn, %{"username" => username, "password" => password}) do
    with :error <- Integer.parse(username) do
      render(conn, "login.json", error: "NID number can only contain characters from 0-9")
    else
      {usernameInteger, _} ->
        case UserManager.authenticate_user(Integer.to_string(usernameInteger), password) do
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
  end

  def api_register(conn, params) do
    case UserManager.create_user(params) do
      {:ok, user} ->
        with {:ok, token, _} <- Guardian.encode_and_sign(user) do
          render(conn, "register.json", status: :ok, token: token)
        else
          _ ->
            render(conn, "register.json", status: :error, reason: "Failed to generate token.")
        end

      {:error, changeset} ->
        render(conn, "register.json", status: :error, changeset: changeset)
    end
  end
end
