defmodule OrderManagement.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :customer, :string
      add :items, {:array, :string}
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
