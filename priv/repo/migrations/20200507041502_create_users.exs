defmodule CovTrackerServer.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :integer
      add :password, :string
      add :type, :integer
      add :phone_number, :integer

      timestamps()
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:phone_number])
  end
end
