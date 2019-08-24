defmodule Authentication.User do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Authentication.Account

  @optional_fields [:account_id]
  @required_fields [:name]

  schema "users" do
    field :name, :string
    belongs_to :account, Account
  end

  def changeset(user, params) do
    user
    |> cast(params, @optional_fields ++ @required_fields)
    |> cast_assoc(:account)
    |> validate_required(@required_fields)
  end
end