# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CovTrackerServer.Repo.insert!(%CovTrackerServer.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias CovTrackerServer.UserManager
alias CovTrackerServer.UserManager.User
alias CovTrackerServer.Infections.Infection
alias CovTrackerServer.Locations.Location
import NaiveDateTime, only: [utc_now: 0, add: 3, truncate: 2]
import CovTrackerServer.Aux, only: [random: 2]
alias CovTrackerServer.Repo
alias Argon2

# Users
UserManager.create_user(%{
  type: 1,
  username: 1_632_162,
  password: "me",
  phone_number: 01_742_284_602,
  label: 0
})

UserManager.create_user(%{
  type: 0,
  username: 1_621_730,
  password: "me",
  phone_number: 01_780_309_689,
  label: 0
})

1..20
|> Enum.map(fn x ->
  %{
    type: 0,
    username: x,
    password: Argon2.hash_pwd_salt("me"),
    phone_number: x,
    inserted_at: truncate(utc_now(), :second),
    updated_at: truncate(utc_now(), :second),
    label: :rand.uniform(6) - 1
  }
end)
|> (fn x -> Repo.insert_all(User, x) end).()

# Left: 23.8459341,89.8137038
# Bottom: 23.7294607,90.3779548
# Top: 23.873957,90.3937476
# Right: 23.8321309,90.4790433

1..200
|> Enum.map(fn _ ->
  %{
    latitude: random(23.7294607, 23.873957),
    longitude: random(89.8137038, 90.4790433),
    altitude: 23.8,
    user_id: :rand.uniform(22),
    timestamp: add(utc_now(), -(:rand.uniform(60 * 60) - 1), :second) |> truncate(:second)
  }
end)
|> (fn x -> Repo.insert_all(Location, x) end).()

1..5
|> Enum.map(fn _ ->
  %{
    user_id: :rand.uniform(22),
    timestamp: add(utc_now(), -(:rand.uniform(60 * 60) - 1), :second) |> truncate(:second),
    inserted_at: truncate(utc_now(), :second),
    updated_at: truncate(utc_now(), :second)
  }
end)
|> (fn x -> Repo.insert_all(Infection, x) end).()
