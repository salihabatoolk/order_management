defmodule OrderManagementWeb.OrderController do
  use OrderManagementWeb, :controller

  alias OrderManagement.Orders.Order
  alias OrderManagement.Orders.OrderService
  alias OrderManagement.Customers.CustomerService

  def index(conn, _params) do
    orders = OrderService.list_orders()
    render(conn, :index, orders: orders)
  end

  def show(conn, %{"id" => id}) do
    case OrderService.get_order(id) do
      nil ->
        conn
        |> put_flash(:error, "Order not found.")
        |> redirect(to: ~p"/orders")

      order ->
        render(conn, :show, order: order)
    end
  end

  def new(conn, _params) do
    changeset = Order.changeset(%Order{}, %{})
    customers = CustomerService.list_customers()

    render(conn, :new,
      changeset: changeset,
      customers: customers
    )
  end

  def edit(conn, %{"id" => id}) do
    case OrderService.get_order(id) do
      nil ->
        conn
        |> put_flash(:error, "Order not found.")
        |> redirect(to: ~p"/orders")

      order ->
        changeset = Order.changeset(order, %{})
        customers = CustomerService.list_customers()

        render(conn, :edit,
          order: order,
          changeset: changeset,
          customers: customers
        )
    end
  end

  def create(conn, %{"order" => order_params}) do
    order_params =
      Map.update(
        order_params,
        "items",
        [],
        &String.split(&1, ",", trim: true)
      )

    case OrderService.create_order(order_params) do
      {:ok, order} ->
        conn
        |> put_status(:created)
        |> render(:show, order: order)

      {:error, changeset} ->
        customers = CustomerService.list_customers()

        conn
        |> put_status(:unprocessable_entity)
        |> render(:new,
          changeset: changeset,
          customers: customers
        )
    end
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = OrderService.get_order(id)

    order_params =
      Map.update(
        order_params,
        "items",
        [],
        &String.split(&1, ",", trim: true)
      )

    case OrderService.update_order(order, order_params) do
      {:ok, order} ->
        render(conn, :show, order: order)

      {:error, changeset} ->
        customers = CustomerService.list_customers()

        conn
        |> put_status(:unprocessable_entity)
        |> render(:edit,
          order: order,
          changeset: changeset,
          customers: customers
        )
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
            send_resp(
              conn,
              :unprocessable_entity,
              "Unable to delete order"
            )
        end
    end
  end
end
