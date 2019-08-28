defmodule Banking.Transaction do
  @moduledoc """
  An atomic record representing a cash inflow or outflow

  For each time a new record is inserted, the wallet's balance needs to be updated

  Note that this is an atomic record and therefore should not be updated, just inserted
  """
  use Ecto.Schema

  import Ecto.Changeset

  @fields [:amount, :customer_id, :type]

  schema "transactions" do
    field(:amount, Money.Ecto.Amount.Type)
    field(:customer_id, :integer)
    field(:type, :string)

    timestamps()
  end

  def changeset(transaction, params) do
    transaction
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_amount_is_positive()
  end

  defp validate_amount_is_positive(%{valid?: false} = changeset), do: changeset

  defp validate_amount_is_positive(changeset) do
    amount = get_field(changeset, :amount)

    if Money.negative?(amount) or Money.zero?(amount) do
      add_error(changeset, :amount, "should be a positive number")
    else
      changeset
    end
  end
end
