defmodule BankingWeb.Router do
  use BankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug BankingWeb.V1.AuthenticationPlug
  end


  scope "/api/v1", BankingWeb, as: :api_v1 do
    pipe_through :api
    pipe_through :authenticated
    
    resources("/customers", V1.CustomerController, only: [:create]) do
      resources("/withdraws", V1.WithdrawController, only: [:create])
    end
  end
  
  scope "/api/v1", BankingWeb, as: :api_v1 do
    pipe_through :api
    
    post("/auth-token", V1.AuthenticationController, :sign_in)
    resources("/users", V1.UserController, only: [:create])
  end
end
