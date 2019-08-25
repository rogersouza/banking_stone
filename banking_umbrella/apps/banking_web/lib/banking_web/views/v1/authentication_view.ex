defmodule BankingWeb.V1.AuthenticationView do
  use BankingWeb, :view

  def render("token.json", %{token: token}) do
    %{token: token}
  end
end