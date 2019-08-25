defmodule BankingWeb.V1.AuthenticationController do
  use BankingWeb, :controller

  def sign_in(conn, credentials) do
    case Authentication.sign_in(credentials) do
      {:ok, token} ->
        conn
        |> put_status(:ok)
        |> render("token.json", %{token: token})
    end
  end
end