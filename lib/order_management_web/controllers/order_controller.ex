defmodule OrderManagementWeb.OrderController do
  use OrderManagementWeb, :controller

  alias OrderManagement.Orders.Order
  alias OrderManagement.Orders.OrderService

  def index(conn, _params) do
    orders = OrderService.list_orders()
    render(conn, :index, orders: orders)
  end

  def show(conn, %{"id" => id}) do
    order = OrderService.get_order(id)
    render(conn, :show, order: order)
  end

  def new(conn, _params) do
    changeset = Order.changeset(%Order{}, %{})
    render(conn, :new, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    order = OrderService.get_order(id)
    changeset = Order.changeset(order, %{})

    render(conn, :edit, order: order, changeset: changeset)
  end

  def create(conn, %{"order" => order_params}) do
    order_params = %{
      order_params
      | "items" => String.split(order_params["items"], ",", trim: true)
    }

    case OrderService.create_order(order_params) do
      {:ok, order} ->
        conn
        |> put_status(:created)
        |> render(:show, order: order)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:new, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = OrderService.get_order(id)

    order_params = %{
      order_params
      | "items" => String.split(order_params["items"], ",", trim: true)
    }

    case OrderService.update_order(order, order_params) do
      {:ok, order} ->
        render(conn, :show, order: order)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:edit, order: order, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case OrderService.get_order(id) do
      nil ->
        send_resp(conn, :not_found, "Order not found")

      order ->
        case OrderService.delete_order(order) do
          {:ok, _order} ->
            redirect(conn, to: ~p"/orders")

          {:error, _changeset} ->
            send_resp(conn, :unprocessable_entity, "Unable to delete order")
        end
    end
  end
end
