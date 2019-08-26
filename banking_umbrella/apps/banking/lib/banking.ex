defmodule Banking do
  alias Banking.Repo
  alias Banking.Customer
  alias Banking.CustomerManager

  def create_customer(customer) do
    customer_changeset = Customer.changeset(%Customer{}, customer)
    multi = CustomerManager.create_customer_multi(customer_changeset)

    case Repo.transaction(multi) do
      {:ok, %{customer: customer, wallet: wallet}} -> {:ok, customer, wallet}
      {:error, :customer, changeset, _} -> {:error, :customer, changeset}
      {:error, :wallet, changeset, _} -> {:error, :wallet, changeset}
    end
  end
end
