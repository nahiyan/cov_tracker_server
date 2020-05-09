defmodule CovTrackerServer.InfectionsTest do
  use CovTrackerServer.DataCase

  alias CovTrackerServer.Infections

  describe "infections" do
    alias CovTrackerServer.Infections.Infection

    @valid_attrs %{timestamp: "2010-04-17T14:00:00Z", user_id: 42}
    @update_attrs %{timestamp: "2011-05-18T15:01:01Z", user_id: 43}
    @invalid_attrs %{timestamp: nil, user_id: nil}

    def infection_fixture(attrs \\ %{}) do
      {:ok, infection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Infections.create_infection()

      infection
    end

    test "list_infections/0 returns all infections" do
      infection = infection_fixture()
      assert Infections.list_infections() == [infection]
    end

    test "get_infection!/1 returns the infection with given id" do
      infection = infection_fixture()
      assert Infections.get_infection!(infection.id) == infection
    end

    test "create_infection/1 with valid data creates a infection" do
      assert {:ok, %Infection{} = infection} = Infections.create_infection(@valid_attrs)
      assert infection.timestamp == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert infection.user_id == 42
    end

    test "create_infection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Infections.create_infection(@invalid_attrs)
    end

    test "update_infection/2 with valid data updates the infection" do
      infection = infection_fixture()
      assert {:ok, %Infection{} = infection} = Infections.update_infection(infection, @update_attrs)
      assert infection.timestamp == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert infection.user_id == 43
    end

    test "update_infection/2 with invalid data returns error changeset" do
      infection = infection_fixture()
      assert {:error, %Ecto.Changeset{}} = Infections.update_infection(infection, @invalid_attrs)
      assert infection == Infections.get_infection!(infection.id)
    end

    test "delete_infection/1 deletes the infection" do
      infection = infection_fixture()
      assert {:ok, %Infection{}} = Infections.delete_infection(infection)
      assert_raise Ecto.NoResultsError, fn -> Infections.get_infection!(infection.id) end
    end

    test "change_infection/1 returns a infection changeset" do
      infection = infection_fixture()
      assert %Ecto.Changeset{} = Infections.change_infection(infection)
    end
  end
end
