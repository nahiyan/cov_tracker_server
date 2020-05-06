defmodule CovTrackerServer.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :nid, :integer
    field :password, :string
    field :phone_number, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:nid, :phone_number, :password])
    |> validate_required([:nid, :phone_number, :password])
  end
end
