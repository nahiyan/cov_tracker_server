defmodule CovTrackerServer.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :user_id, :integer
      add :longitude, :decimal
      add :latitude, :decimal
      add :altitude, :decimal
      add :timestamp, :naive_datetime
    end
  end
end
