defmodule CovTrackerServer.Repo.Migrations.CreateInfections do
  use Ecto.Migration

  def change do
    create table(:infections) do
      add :user_id, :integer
      add :timestamp, :naive_datetime

      timestamps()
    end
  end
end
