defmodule CovTrackerServer.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :nid, :integer
      add :phone_number, :string
      add :password, :string

      timestamps()
    end

  end
end
