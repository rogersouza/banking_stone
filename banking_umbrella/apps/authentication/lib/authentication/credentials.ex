defmodule Authentication.Credentials do
  @moduledoc """
  An Ecto Schema that ensures the integrity of `sign in` requests

  ## Example of a valid credentials structure
  ```json
  {
    "email": "some_email@mail.com",
    "password": "some_password123"
  }
  ```
  """
  use Ecto.Schema

  import Ecto.Changeset

  @fields [:email, :password]

  embedded_schema do
    field(:email, :string)
    field(:password, :string)
    field(:password_hash, :string)
  end

  def changeset(credentials, params) do
    credentials
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
