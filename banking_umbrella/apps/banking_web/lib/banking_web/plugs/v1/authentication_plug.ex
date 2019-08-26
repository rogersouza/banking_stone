defmodule BankingWeb.V1.AuthenticationPlug do
  @moduledoc"""
  Ensures that whoever is trying to access our API has a valid token
  """
  import Plug.Conn
  import Phoenix.Controller, only: [render: 2, put_view: 2]

  @error_view BankingWeb.ErrorView

  def init(_options), do: nil

  def call(conn, _params) do
    token = conn |> get_req_header("authorization") |> token()

    case Authentication.Guardian.decode_and_verify(token) do
      {:ok, %{"sub" => account_id}} ->
        conn
        |> assign(:account_id, String.to_integer(account_id))

      {:error, _any} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(@error_view)
        |> render("401.json")
        |> halt()
    end
  end

  defp token(["Bearer " <> token]), do: token
  defp token(_), do: ""
end
