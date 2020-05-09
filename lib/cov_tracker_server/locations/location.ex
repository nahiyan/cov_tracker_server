defmodule CovTrackerServer.Locations.Location do
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
    |> cast(attrs, [:altitude, :latitude, :longitude, :timestamp, :user_id])
    |> validate_required([:altitude, :latitude, :longitude, :timestamp, :user_id])
  end
end
