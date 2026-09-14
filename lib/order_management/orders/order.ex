defmodule OrderManagement.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :customer, :string
    field :items, {:array, :string}
    field :status, Ecto.Enum, values: [:pending, :completed, :cancelled]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:customer, :items, :status])
    |> validate_required([:customer, :items, :status])
  end
end
