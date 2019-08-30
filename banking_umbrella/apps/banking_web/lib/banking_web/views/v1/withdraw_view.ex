defmodule BankingWeb.V1.WithdrawView do
  use BankingWeb, :view

  def render("balance.json", %{wallet: wallet}) do
    %{balance: Money.to_string(wallet.balance), customer_id: wallet.customer_id}
  end

  def render("insufficient_funds.json", _) do
    %{message: "Insufficient funds"}
  end
end
