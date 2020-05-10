defmodule CovTrackerServer.Infections.Infection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "infections" do
    field :timestamp, :naive_datetime
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(infection, attrs) do
    infection
    |> cast(attrs, [:user_id, :timestamp])
    |> validate_required([:user_id, :timestamp])
  end
end
