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

    test "in case of invalid credentials, a 401 status code is returned", %{conn: conn} do
      credentials = %{"email" => @email, "password" => "wrong_password"}
      login_path = api_v1_authentication_path(conn, :sign_in)

      conn = post(conn, login_path, credentials)
      assert json_response(conn, 401)
    end

    test "in case of missing fields on the credentials request, returns 400", %{conn: conn} do
      malformed_credentials = %{"email" => @email}
      login_path = api_v1_authentication_path(conn, :sign_in)
      
      conn = post(conn, login_path, malformed_credentials)
      assert json_response(conn, 400)
    end
  end
end
