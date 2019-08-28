defmodule BankingTest do
  use Banking.DataCase
  use Bamboo.Test
  
  import Ecto.Query

  alias Banking.Repo

  @initial_balance Application.get_env(:banking, :initial_balance)

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
      one_thousand = Application.get_env(:banking, :initial_balance) |> Money.new()

      wallet_balance = wallet_balance(customer.id)
      assert wallet_balance != nil, message: "the wallet isn't created for this customer"

      assert Money.equals?(customer_balance, one_thousand),
        message: "the customer's balance should be 1000"
    end
  end

  describe "withdraw/2" do
    setup do
      {:ok, customer} = Banking.create_customer(@customer_fixture)
      [customer: customer]
    end

    test "takes the given value out of the customer's wallet", %{customer: customer} do
      withdrawn = Money.parse!("500,00")

      balance_before_withdraw = wallet_balance(customer.id)
      {:ok, _balance} = Banking.withdraw(withdrawn, customer.id)

      assert wallet_balance(customer.id) != balance_before_withdraw,
        message: "the balance still the same"

      expected_balance = Money.subtract(Money.new(@initial_balance), withdrawn)
      actual_balance = wallet_balance(customer.id)

      assert actual_balance == expected_balance,
        message:
          "the wallet's balance should be #{expected_balance.amount} but was #{
            actual_balance.amount
          }"
    end

    test "doesn't accept a negative amount", %{customer: customer} do
      negative_amount = "- 2,50"
      {:error, withdraw} = Banking.withdraw(negative_amount, customer.id)
      assert "should be a positive number" in errors_on(withdraw).amount
    end

    test "doesn't allow a amount value greater than the wallet balance", %{customer: customer} do
      current_balance = wallet_balance(customer.id)
      amount = Money.new(current_balance.amount + 10_000)
      assert {:error, :insufficient_funds} = Banking.withdraw(amount, customer.id)
    end

    test "creates a transaction record of type 'withdraw'", %{customer: customer} do
      {:ok, _balance} = Banking.withdraw("500,00", customer.id)
      
      withdraw_transaction = Repo.one(Banking.Transaction)
      assert withdraw_transaction.type == "withdraw"
    end

    test "sends to the customer a email reporting the withdraw", %{customer: customer} do
      amount = Money.new(50_000)
      {:ok, _balance} = Banking.withdraw(amount, customer.id)

      withdrawal_email = Banking.Mailer.Email.withdrawal(customer, amount)
      assert_delivered_email withdrawal_email
    end
  end
end
