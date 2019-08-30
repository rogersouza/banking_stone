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
    
    resources("/customer", V1.CustomerController, only: [:create]) do
      resources("/withdraw", V1.WithdrawController, only: [:create])
    end
  end
  
  scope "/api/v1", BankingWeb, as: :api_v1 do
    pipe_through :api
    
    post("/login", V1.AuthenticationController, :sign_in)
    resources("/user", V1.UserController, only: [:create])
  end
end
