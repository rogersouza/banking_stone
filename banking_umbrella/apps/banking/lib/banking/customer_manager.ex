defmodule Banking.CustomerManager do
  alias Ecto.Multi
  alias Banking.Wallet

  @initial_balance Application.get_env(:banking, :initial_balance)

  def create_customer_multi(customer_changeset) do
    Multi.new()
    |> Multi.insert(:customer, customer_changeset)
    |> Multi.run(:wallet, &give_initial_balance/2)
  end

  def give_initial_balance(_repo, %{customer: customer}) do
    %Wallet{}
    |> Wallet.changeset(%{customer_id: customer.id, balance: @initial_balance})
    |> Banking.Repo.insert()
  end
end
