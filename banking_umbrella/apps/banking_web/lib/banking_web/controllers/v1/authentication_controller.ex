defmodule BankingWeb.V1.AuthenticationController do
  use BankingWeb, :controller

  def sign_in(conn, credentials) do
    case Authentication.sign_in(credentials) do
      {:ok, token} ->
        conn
        |> put_status(:ok)
        |> render("token.json", %{token: token})

      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(BankingWeb.ErrorView)
        |> render("401.json")
    end
  end
end