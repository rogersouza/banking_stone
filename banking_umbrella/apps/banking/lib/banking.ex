defmodule Banking do
  @moduledoc false
  alias Banking.Repo
  alias Banking.{Customer, Wallet}

  @initial_balance Application.get_env(:banking, :initial_balance)

  @doc """
  Create a new customer and gives him/her 1000$

  # Usage
  ```
  customer = %{"email" => "customer@mail.com", "name" => "Customer"}

  case Banking.create_customer(customer) do
    {:ok, customer} -> # Do something with the customer
    {:error, changeset} -> # Check the changeset errors
  end
  ```
  """
  @spec create_customer(map()) :: {:ok, Customer.t()} | {:error, Ecto.Changeset.t()}
  def create_customer(customer) do
    %Customer{wallet: %Wallet{balance: @initial_balance}}
    |> Customer.changeset(customer)
    |> Ecto.Changeset.cast_assoc(:wallet, required: true)
    |> Repo.insert()
  end
end
