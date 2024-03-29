defmodule Banking do
  @moduledoc false
  
  alias Banking.Repo
  alias Banking.{Customer, Wallet, TransactionManager}
  alias Banking.Mailer
  alias Banking.Mailer.Email

  @type amount() :: String.t() | Money.t()

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

  @doc """
  Withdraws a given amount from customer's wallet

  # Possible Scenarios

  ## A successful withdraw happens
  ```elixir
  # Wallet's balance -> 100,00
  {:ok, %Wallet{}} = Banking.withdraw("50,0", customer_id)
  ```
  In this case, a email will be send indicating the withdrawal

  ## Someone tries to withdraw more money than they have in their wallet

  ```elixir
  # Wallet's balance -> 100,00
  amount = "500,0"
  {:error, :insufficient_funds} = Banking.withdraw(amount, customer)
  ```

  ## A malformed amount is passed as argument
  A valid amount can be either a Money struct or a string that holds a numeric
  value, besides than, a changeset containing the cast error will be returned

  ```elixir
  amount = "invalid amount"
  {:error, changeset} = Banking.withdraw(amount, customer)
  ```

  You can check https://hexdocs.pm/money/Money.html#parse/3 for more information

  ## A customer_id that is not bound to any customer in the database
  In this particular case, a `Ecto.NoResultsError` will be raised. 

  """
  @spec withdraw(amount(), String.t() | integer()) ::
          {:ok, Wallet.t()} | {:error, :insufficient_funds} | {:error, Ecto.Changeset.t()}
  def withdraw(amount, customer_id) do
    customer = Repo.get!(Customer, customer_id)

    amount
    |> TransactionManager.withdraw(customer.id)
    |> Repo.transaction()
    |> case do
      {:ok, %{wallet: wallet, transaction: transaction}} ->
        customer
        |> Email.withdrawal(transaction.amount)
        |> Mailer.deliver_now()

        {:ok, wallet}

      {:error, :wallet, wallet_changeset, _} ->
        {:error, wallet_changeset}

      {:error, :transaction, changeset, _} ->
        {:error, changeset}
    end
  end
end
