defmodule OrderManagement.Orders.OrderService do
  import Ecto.Query

  alias OrderManagement.Repo
  alias OrderManagement.Orders.Order

  def list_orders do
    Order
    |> Repo.all()
    |> Repo.preload(:customer)
  end

  def list_orders_by_status(status) do
    Order
    |> where([o], o.status == ^status)
    |> Repo.all()
    |> Repo.preload(:customer)
  end

  def get_order(id) do
    Order
    |> Repo.get(id)
    |> Repo.preload(:customer)
  end

  def create_order(attrs) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
    |> preload_customer()
  end

  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
    |> preload_customer()
  end

  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  defp preload_customer({:ok, order}) do
    {:ok, Repo.preload(order, :customer)}
  end

  defp preload_customer({:error, changeset}) do
    {:error, changeset}
  end
end
