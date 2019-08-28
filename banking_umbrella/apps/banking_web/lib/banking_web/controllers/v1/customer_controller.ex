defmodule BankingWeb.V1.CustomerController do
  use BankingWeb, :controller

  import Banking

  def create(conn, customer) do
    case create_customer(customer) do
      {:ok, customer} ->
        conn
        |> put_status(:created)
        |> json(customer)

      {:error, %{errors: [email: {"has already been taken", _}]} = changeset} ->
        conn
        |> put_status(:conflict)
        |> put_view(BankingWeb.ErrorView)
        |> render("409.json", changeset)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(BankingWeb.ErrorView)
        |> render("400.json", changeset)
    end
  end

  def withdraw(conn, %{"id" => id, "amount" => amount}) do
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
