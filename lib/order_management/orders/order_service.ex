defmodule OrderManagement.Orders.OrderService do
  alias OrderManagement.Repo
  alias OrderManagement.Orders.Order

  def list_orders do
    Repo.all(Order)
  end

  def get_order(id) do
    Repo.get(Order, id)
  end

  def create_order(attrs) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end
end
