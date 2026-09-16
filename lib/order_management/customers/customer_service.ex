defmodule OrderManagement.Customers.CustomerService do
  alias OrderManagement.Repo
  alias OrderManagement.Customers.Customer

  def list_customers do
    Repo.all(Customer)
  end

  def get_customer(id) do
    Repo.get(Customer, id)
  end

  def create_customer(attrs) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end

  def update_customer(%Customer{} = customer, attrs) do
    customer
    |> Customer.changeset(attrs)
    |> Repo.update()
  end

  def delete_customer(%Customer{} = customer) do
    Repo.delete(customer)
  end
end
