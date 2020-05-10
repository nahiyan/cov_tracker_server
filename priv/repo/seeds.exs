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

1..50
|> Enum.map(fn x ->
  %{
    type: 0,
    username: x,
    password: Argon2.hash_pwd_salt("me"),
    phone_number: x,
    inserted_at: truncate(utc_now(), :second),
    updated_at: truncate(utc_now(), :second),
    label: 0
  }
end)
|> (fn x -> Repo.insert_all(User, x) end).()

1..100
|> Enum.map(fn _ ->
  %{
    latitude: random(23.812142, 23.812378),
    longitude: random(90.413166, 90.414432),
    altitude: 23.8,
    user_id: :rand.uniform(52),
    timestamp: add(utc_now(), -(:rand.uniform(60 * 60) - 1), :second) |> truncate(:second)
  }
end)
|> (fn x -> Repo.insert_all(Location, x) end).()

# Infections
1..10
|> Enum.map(fn i ->
  %{
    user_id: i,
    timestamp: add(utc_now(), -(:rand.uniform(60 * 60) - 1), :second) |> truncate(:second),
    inserted_at: truncate(utc_now(), :second),
    updated_at: truncate(utc_now(), :second)
  }
end)
|> (fn x -> Repo.insert_all(Infection, x) end).()

# Implicitly add orange people
