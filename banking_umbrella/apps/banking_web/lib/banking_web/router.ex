defmodule BankingWeb.Router do
  use BankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :put_view, BankingWeb.ErrorView
  end

  scope "/api/v1", BankingWeb, as: :api_v1 do
    pipe_through :api

    resources("/user", V1.UserController, only: [:create])
  end
end
