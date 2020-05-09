defmodule CovTrackerServer.Infections do
  @moduledoc """
  The Infections context.
  """

  import Ecto.Query, warn: false
  alias CovTrackerServer.Repo

  alias CovTrackerServer.Infections.Infection

  @doc """
  Returns the list of infections.

  ## Examples

      iex> list_infections()
      [%Infection{}, ...]

  """
  def list_infections do
    Repo.all(Infection)
  end

  @doc """
  Gets a single infection.

  Raises `Ecto.NoResultsError` if the Infection does not exist.

  ## Examples

      iex> get_infection!(123)
      %Infection{}

      iex> get_infection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_infection!(id), do: Repo.get!(Infection, id)

  @doc """
  Creates a infection.

  ## Examples

      iex> create_infection(%{field: value})
      {:ok, %Infection{}}

      iex> create_infection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_infection(attrs \\ %{}) do
    %Infection{}
    |> Infection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a infection.

  ## Examples

      iex> update_infection(infection, %{field: new_value})
      {:ok, %Infection{}}

      iex> update_infection(infection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_infection(%Infection{} = infection, attrs) do
    infection
    |> Infection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a infection.

  ## Examples

      iex> delete_infection(infection)
      {:ok, %Infection{}}

      iex> delete_infection(infection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_infection(%Infection{} = infection) do
    Repo.delete(infection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking infection changes.

  ## Examples

      iex> change_infection(infection)
      %Ecto.Changeset{source: %Infection{}}

  """
  def change_infection(%Infection{} = infection) do
    Infection.changeset(infection, %{})
  end
end
