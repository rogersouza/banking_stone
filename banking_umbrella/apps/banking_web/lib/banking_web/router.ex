defmodule BankingWeb.Router do
  use BankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", BankingWeb, as: :api_v1 do
    pipe_through :api

    resources("/user", V1.UserController, only: [:create])
    post("/login", V1.AuthenticationController, :sign_in)

    resources("/customer", V1.CustomerController, only: [:create])
  end
end
