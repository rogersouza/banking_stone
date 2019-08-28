defmodule Banking.Withdraw do
  use Ecto.Schema
  
  import Ecto.Changeset

  @fields [:amount, :source_customer_id] 

  schema "transactions" do
    field :amount, Money.Ecto.Amount.Type
    field :customer_id, :integer
    field :type, :string, default: "withdraw"

    timestamps()
  end

  def changeset(withdraw, params) do
    withdraw
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_amount_is_positive()
  end

  defp validate_amount_is_positive(%{valid?: false} = changeset), do: changeset
  defp validate_amount_is_positive(changeset) do
    amount = get_field(changeset, :amount) |> IO.inspect(label: "amount")

    if Money.negative?(amount) do
      add_error(changeset, :amount, "should be a positive number")
    else
      changeset
    end
  end
end