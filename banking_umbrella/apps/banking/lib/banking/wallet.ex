defmodule Banking.Wallet do
  use Ecto.Schema

  import Ecto.Changeset

  @required_fields [:customer_id, :balance]
  @optional_fields []

  schema "wallets" do
    belongs_to :customer, Banking.Customer
    field :balance, Money.Ecto.Amount.Type
  end

  def changeset(wallet, params) do
    wallet
    |> cast(params, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
