defmodule BankingWeb.V1.UserController do
  use BankingWeb, :controller

  def create(conn, user) do
    case Authentication.register(user) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(user)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render("400.json", changeset)
    end
  end
end
