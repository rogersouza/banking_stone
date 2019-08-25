defmodule BankingWeb.V1.UserControllerTest do
  use BankingWeb.ConnCase

  import Routes

  @user_fixture %{
    "account" => %{"email" => "jane@mail.com", "password" => "jane123"},
    "name" => "Jane Doe"
  }

  describe "create/2" do
    test "creates a new user and return it to the requester", %{conn: conn} do
      response =
        conn
        |> post(api_v1_user_path(conn, :create), @user_fixture)
        |> json_response(:created)

      expected_email = @user_fixture["account"]["email"]
      expected_name = @user_fixture["name"]

      assert %{"email" => ^expected_email} = response["account"]
      assert %{"name" => ^expected_name} = response
    end

    test "returns 201 on successfuly created user", %{conn: conn} do
      conn = post(conn, api_v1_user_path(conn, :create), @user_fixture)
      assert json_response(conn, 201)
    end

    test "returns 400 in case of validation errors", %{conn: conn} do
      account = %{"email" => "invalid_email.com", "password" => "password123"}
      user_fixture = %{@user_fixture | "account" => account}
      conn = post(conn, api_v1_user_path(conn, :create), user_fixture)

      assert json_response(conn, 400)
    end
  end
end
