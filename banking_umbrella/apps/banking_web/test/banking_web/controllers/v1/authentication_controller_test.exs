defmodule BankingWeb.V1.AuthenticationControllerTest do
  use BankingWeb.ConnCase

  import Routes

  @email "test@mail.com"
  @password "pwd123"

  def insert_user(_context) do
    user = %{"name" => "User", "account" => %{"email" => @email, "password" => @password}}
    {:ok, _user} = Authentication.register(user)
    :ok
  end

  describe "sign_in/2" do
    setup :insert_user

    test "in case of valid credentials, returns a token", %{conn: conn} do
      credentials = %{"email" => @email, "password" => @password}
      login_path = api_v1_authentication_path(conn, :sign_in)

      response =
        conn
        |> post(login_path, credentials)
        |> json_response(200)

      assert Map.has_key?(response, "token")
    end
  end
end
