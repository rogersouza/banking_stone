defmodule Authentication.Account do
  @moduledoc false
  
  use Ecto.Schema

  import Ecto.Changeset

  alias Authentication.Encryptor

  @optional_fields []
  @required_fields [:email, :password]

  schema "accounts" do
    field(:email, :string)
    field(:password, :string)
  end

  def changeset(account, params) do
    account
    |> cast(params, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(changeset) do
    if changeset.valid? do
      hashed_password =
        changeset
        |> get_field(:password)
        |> Encryptor.encrypt()

      put_change(changeset, :password, hashed_password)
    else
      changeset
    end
  end
end
