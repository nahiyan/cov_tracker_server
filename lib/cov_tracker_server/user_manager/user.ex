defmodule CovTrackerServer.UserManager.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Argon2

  schema "users" do
    field :username, :integer
    field :password, :string
    field :phone_number, :integer
    field :type, :integer
    field :label, :integer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :type, :phone_number])
    |> unique_constraint(:username)
    |> unique_constraint(:phone_number)
    |> validate_required([:username, :password, :type, :phone_number])
    |> validate_number(:phone_number, greater_than: 0)
    |> validate_number(:username, greater_than: 0)
    |> validate_confirmation(:password, message: "passwords do not match")
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
