defmodule OrderManagementWeb.PageController do
  use OrderManagementWeb, :controller

  alias OrderManagement.Orders.OrderService
  alias OrderManagement.Customers.CustomerService

  def home(conn, _params) do
    orders = OrderService.list_orders()
    customers = CustomerService.list_customers()

    pending_orders =
      Enum.count(orders, fn order ->
        order.status == :pending
      end)

    completed_orders =
      Enum.count(orders, fn order ->
        order.status == :completed
      end)

    cancelled_orders =
      Enum.count(orders, fn order ->
        order.status == :cancelled
      end)

    render(conn, :home,
      orders_count: length(orders),
      customers_count: length(customers),
      pending_orders: pending_orders,
      completed_orders: completed_orders,
      cancelled_orders: cancelled_orders
    )
  end
end
