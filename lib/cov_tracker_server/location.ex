defmodule CovTrackerServer.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :altitude, :decimal
    field :latitude, :decimal
    field :longitude, :decimal
    field :timestamp, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:user_id, :longitude, :latitude, :altitude, :timestamp])
    |> validate_required([:user_id, :longitude, :latitude, :altitude, :timestamp])
  end
end
