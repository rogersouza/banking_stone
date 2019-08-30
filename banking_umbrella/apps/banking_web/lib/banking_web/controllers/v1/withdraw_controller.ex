defmodule BankingWeb.V1.WithdrawController do
  use BankingWeb, :controller

  def create(conn, %{"customer_id" => id, "amount" => amount}) do
    case Banking.withdraw(amount, id) do
      {:ok, wallet} ->
        conn
        |> put_status(:ok)
        |> render("balance.json", %{wallet: wallet})

      {:error, :insufficient_funds} ->
        conn
        |> put_status(:bad_request)
        |> render("insufficient_funds.json")

      {:error, changeset} ->
        conn
        |> put_view(BankingWeb.ErrorView)
        |> put_status(:bad_request)
        |> render("400.json", changeset)
    end
  end
end
