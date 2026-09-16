
defmodule OrderManagementWeb.CustomerController do
  use OrderManagementWeb, :controller

  alias OrderManagement.Customers.Customer
  alias OrderManagement.Customers.CustomerService

  def index(conn, _params) do
    customers = CustomerService.list_customers()
    render(conn, :index, customers: customers)
  end

  def show(conn, %{"id" => id}) do
    customer = CustomerService.get_customer(id)
    render(conn, :show, customer: customer)
  end

  def new(conn, _params) do
    changeset = Customer.changeset(%Customer{}, %{})
    render(conn, :new, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    customer = CustomerService.get_customer(id)
    changeset = Customer.changeset(customer, %{})
    render(conn, :edit, customer: customer, changeset: changeset)
  end

  def create(conn, %{"customer" => customer_params}) do
    case CustomerService.create_customer(customer_params) do
      {:ok, customer} ->
        conn
        |> put_flash(:info, "Customer created successfully.")
        |> redirect(to: ~p"/customers/#{customer.id}")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:new, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "customer" => customer_params}) do
    customer = CustomerService.get_customer(id)

    case CustomerService.update_customer(customer, customer_params) do
      {:ok, customer} ->
        conn
        |> put_flash(:info, "Customer updated successfully.")
        |> redirect(to: ~p"/customers/#{customer.id}")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:edit,
          customer: customer,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    customer = CustomerService.get_customer(id)

    case CustomerService.delete_customer(customer) do
      {:ok, _customer} ->
        conn
        |> put_flash(:info, "Customer deleted successfully.")
        |> redirect(to: ~p"/customers")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Unable to delete customer.")
        |> redirect(to: ~p"/customers")
    end
  end
end
