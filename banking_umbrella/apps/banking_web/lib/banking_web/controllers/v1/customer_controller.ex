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
end
