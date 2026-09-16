defmodule OrderManagement.Repo.Migrations.AddEmailToCustomers do
  use Ecto.Migration

  def change do
    alter table(:customers) do
      add :email, :string
    end
  end
end
