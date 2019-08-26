defmodule BankingTest do
  use Banking.DataCase

  import Ecto.Query

  alias Banking.Repo

  @customer_fixture %{
    "name" => "Jane Doe",
    "email" => "jane_doe@mail.com"
  }

  defp wallet_balance(customer_id) do
    "wallets"
    |> where([w], w.customer_id == ^customer_id)
    |> select([w], w.balance)
    |> Repo.one()
    |> Money.new()
  end

  describe "create_customer/2" do
    test "creates a new customer" do
      assert {:ok, _customer} = Banking.create_customer(@customer_fixture)
    end

    test "rejects duplicated emails" do
      {:ok, _customer} = Banking.create_customer(@customer_fixture)
      {:error, changeset} = Banking.create_customer(@customer_fixture)
      assert "has already been taken" in errors_on(changeset).email
    end

    test "gives the user a initial balance of 1000" do
      {:ok, customer} = Banking.create_customer(@customer_fixture)
      customer_balance = wallet_balance(customer.id)
      one_thousand = Money.new(1000)

      wallet_balance = wallet_balance(customer.id)
      assert wallet_balance != nil, message: "the wallet isn't created for this customer"

      assert Money.equals?(customer_balance, one_thousand),
        message: "the customer's balance should be 1000"
    end
  end
end
