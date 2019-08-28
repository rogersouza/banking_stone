defmodule Banking.Mailer.Email do
  @moduledoc false
  
  import Bamboo.Email

  def withdrawal(customer, %Money{} = amount) do
    text_body = message(customer, amount)

    new_email()
    |> from("banking@noreply.com")
    |> to(customer.email)
    |> text_body(text_body)
  end

  defp message(customer, amount) do
    """
    Hi #{customer.name}!

    #{Money.to_string(amount, symbol: true)} was withdrawn from you wallet!
    """
  end
end