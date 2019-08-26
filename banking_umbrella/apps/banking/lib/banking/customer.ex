defmodule Banking.Customer do
  use Ecto.Schema
  
  import Ecto.Changeset

  @fields [:name, :email]

  schema "customers" do
    field :name, :string
    field :email, :string
  end

  def changeset(customer, params) do
    customer
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end