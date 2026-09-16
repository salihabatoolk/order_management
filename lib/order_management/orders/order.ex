defmodule OrderManagement.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :items, {:array, :string}
    field :status, Ecto.Enum, values: [:pending, :completed, :cancelled]

    belongs_to :customer, OrderManagement.Customers.Customer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:customer_id, :items, :status])
    |> validate_required([:customer_id, :items, :status])
  end
end
