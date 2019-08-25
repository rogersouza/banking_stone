defmodule Authentication do
  @moduledoc """
  Holds all the authentication logic
  """
  alias Banking.Repo
  alias Authentication.{User, Account, Encryptor}

  @doc """
  Register a new user

  ## Example
  ```
  iex> account = %{"email" => "user@mail.com", "password" => "password123"}
  iex> user = %{"name" => "User Name", "account" => account}
  iex> {:ok, _new_user} = Authentication.register(user)
  ```
  """
  @spec register(user_attrs :: map()) :: {:error, Ecto.Changeset.t()} | {:ok, User.t()}
  def register(user_attrs) do
    %User{}
    |> User.changeset(user_attrs)
    |> Repo.insert()
  end
end
