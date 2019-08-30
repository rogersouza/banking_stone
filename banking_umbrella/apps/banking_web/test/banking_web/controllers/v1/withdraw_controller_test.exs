defmodule BankingWeb.V1.WithdrawControllerTest do
  use BankingWeb.ConnCase

  import Routes
  
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Banking.Repo)
  end

  @initial_balance Application.get_env(:banking, :initial_balance)

  @email "test@mail.com"
  @password "password123456"
  @user_fixture %{
    "account" => %{"email" => @email, "password" => @password},
    "name" => "Tester"
  }

  describe "create/2" do
    setup %{conn: conn} do
      {:ok, _user} = Authentication.register(@user_fixture)
      {:ok, token} = Authentication.sign_in(%{"email" => @email, "password" => @password})
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      customer = %{"email" => "jane@mail.com", "name" => "Jane Doe"}
      {:ok, customer} = Banking.create_customer(customer)

      [customer: customer, conn: conn]
    end

    test "returns 200 on successful withdraws", %{conn: conn, customer: customer} do
      withdraw_path = api_v1_customer_withdraw_path(conn, :create, customer.id)
      request_body = %{"amount" => "500,00"}
      conn = post(conn, withdraw_path, request_body)

      assert json_response(conn, 200)
    end

    test "returns the wallet's balance after the withdraw", %{conn: conn, customer: customer} do
      withdraw_path = api_v1_customer_withdraw_path(conn, :create, customer.id)
      request_body = %{"amount" => "500,00"}
      response = conn |> post(withdraw_path, request_body) |> json_response(200)
      
      assert response["balance"] != nil, message: "the balance hasn't be retrieved"
    end

    test "returns 400 if the amount is negative", %{conn: conn, customer: customer} do
      withdraw_path = api_v1_customer_withdraw_path(conn, :create, customer.id)
      request_body = %{"amount" => "- 500,00"}
      conn = conn |> post(withdraw_path, request_body)

      assert json_response(conn, 400)
    end

    test "returns a insufficient fund error", %{conn: conn, customer: customer} do
      withdraw_path = api_v1_customer_withdraw_path(conn, :create, customer.id)
      request_body = %{"amount" => "#{Money.new(@initial_balance + 1)}"}
      conn = conn |> post(withdraw_path, request_body)
      
      assert json_response(conn, 400)
    end
  end
end
