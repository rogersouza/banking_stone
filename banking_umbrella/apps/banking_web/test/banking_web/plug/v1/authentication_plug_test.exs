defmodule BankingWeb.V1.AuthenticationPlugTest do
  use BankingWeb.ConnCase

  @email "user@mail.com"
  @password "1234"

  @user_fixture %{
    "account" => %{"email" => @email, "password" => @password},
    "name" => "User"
  }

  setup do
    {:ok, user} = Authentication.register(@user_fixture)
    {:ok, token} = Authentication.sign_in(%{"email" => @email, "password" => @password})

    [user: user, token: token]
  end

  test "returns status 401 for requests without a token", %{conn: conn} do
    conn = BankingWeb.V1.AuthenticationPlug.call(conn, %{})
    assert conn.status == 401
  end

  test "puts the user_id on assigns", %{conn: conn, user: user, token: token} do
    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> BankingWeb.V1.AuthenticationPlug.call(%{})

    assert conn.assigns.account_id == user.account.id
  end
end
