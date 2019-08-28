defmodule Banking.TransactionManager do
  @moduledoc false

  @type amount() :: String.t() | Money.t()

  alias Ecto.Multi

  alias Banking.{
    Repo,
    Transaction,
    Wallet
  }

  @doc """
  It builds a multi structure that represents a complete withdraw, which
  has 3 steps:

  - Create a transaction that represents the withdraw (%Transaction{} of type "withdraw")
  - Subtract wallet's balance
  """
  def withdraw(amount, customer_id) do
    changeset = withdraw_transaction(amount, customer_id)

    Multi.new()
    |> Multi.insert(:transaction, changeset)
    |> Multi.run(:wallet, &subtract_from_wallet/2)
  end

  defp withdraw_transaction(amount, customer_id) do
    params = %{amount: amount, customer_id: customer_id, type: "withdraw"}
    Transaction.changeset(%Transaction{}, params)
  end

  # To make pattern matching easier, this function will return
  # {:error, :insufficient_funds}
  # instead of
  # {:error, changeset}
  defp subtract_from_wallet(_repo, %{transaction: transaction}) do
    wallet = Repo.get_by(Wallet, customer_id: transaction.customer_id)
    new_balance = Money.subtract(wallet.balance, transaction.amount)

    wallet
    |> Wallet.changeset(%{balance: new_balance})
    |> Repo.update()
    |> case do
      {:ok, wallet} ->
        {:ok, wallet}

      {:error, %{errors: [balance: {"insufficient funds", _}]}} ->
        {:error, :insufficient_funds}

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
