defmodule OrderManagement.Repo.Migrations.AddPhoneToCustomers do
  use Ecto.Migration

  def change do
    alter table(:customers) do
      add :phone, :string
    end
  end
end
