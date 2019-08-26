defmodule BankingWeb.V1.CustomerControllerTest do
  use BankingWeb.ConnCase

  import Routes

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Banking.Repo)
  end

  describe "create/2" do
    test "returns 201 when users is created", %{conn: conn} do
      customer = %{"email" => "jane@mail.com", "name" => "Jane Doe"}
      conn = post(conn, api_v1_customer_path(conn, :create), customer)
      assert json_response(conn, 201)
    end

    test "returns 400 if the request's body is missing customer's email", %{conn: conn} do
      customer = %{"name" => "Jane Doe"}
      conn = post(conn, api_v1_customer_path(conn, :create), customer)
      assert json_response(conn, 400)
    end

    test "returns 400 if the request's body is missing customer's name", %{conn: conn} do
      customer = %{"email" => "jane@mail.com"}
      conn = post(conn, api_v1_customer_path(conn, :create), customer)
      assert json_response(conn, 400)
    end

    test "returns 409 if there's already a customer with this email", %{conn: conn} do
      customer = %{"email" => "jane@mail.com", "name" => "Jane Doe"}
      Banking.create_customer(customer)
      
      conn = post(conn, api_v1_customer_path(conn, :create), customer)
      assert json_response(conn, 409)
    end
  end
end
