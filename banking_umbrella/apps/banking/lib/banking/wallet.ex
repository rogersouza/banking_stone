defmodule Banking.Wallet do
  @moduledoc """
  A customer's wallet. It holds the current balance of a customer.

  After a transaction is inserted, the balance should be updated.

  A WALLET SHOULD ALWAYS HAVE A POSITIVE BALANCE
  """

  use Ecto.Schema

  import Ecto.Changeset

  @required_fields [:customer_id, :balance]
  @optional_fields []

  schema "wallets" do
    belongs_to(:customer, Banking.Customer)
    field(:balance, Money.Ecto.Amount.Type)
  end

  def changeset(wallet, params) do
    wallet
    |> cast(params, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> check_constraint(:balance,
      name: :balance_must_be_positive,
      message: "insufficient funds"
    )
  end
end
