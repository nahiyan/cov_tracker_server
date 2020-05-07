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

UserManager.create_user(%{
  type: 1,
  username: 1_632_162,
  password: "me",
  phone_number: 01_742_284_602
})

UserManager.create_user(%{
  type: 0,
  username: 1_621_730,
  password: "me",
  phone_number: 01_780_309_689
})
