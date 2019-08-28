defmodule Banking.TransactionManager do
  alias Ecto.Multi
  alias Banking.Wallet
  alias Banking.Repo
  alias Banking.Customer
  alias Banking.Transaction

  def withdraw(%{changes: transaction} = changeset) do
    Multi.new()
    |> Multi.insert(:transaction, changeset)
    |> Multi.run(:wallet, &subtract_from_wallet/2)
  end

  defp subtract_from_wallet(_repo, %{transaction: transaction}) do
    wallet = Repo.get_by(Wallet, customer_id: transaction.customer_id)
    new_balance = Money.subtract(wallet.balance, transaction.amount)

    wallet
    |> Wallet.changeset(%{balance: new_balance})
    |> Repo.update()
  end

  def can_withdraw?(%{changes: transaction}) do
    wallet = Repo.get_by(Wallet, customer_id: transaction.customer_id)
    wallet.balance >= transaction.amount
  end
end
