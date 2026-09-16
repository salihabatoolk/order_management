defmodule OrderManagement.Customers.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :name, :string
    field :email, :string

    has_many :orders, OrderManagement.Orders.Order

    timestamps(type: :utc_datetime)
  end

  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
  end
end
