defmodule BankingWeb.V1.AuthenticationController do
  use BankingWeb, :controller

  def create(conn, credentials) do
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

      {:error, :malformed_credentials, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(BankingWeb.ErrorView)
        |> render("400.json", changeset)
    end
  end
end