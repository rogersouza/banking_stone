defmodule Authentication do
  @moduledoc """
  Holds all the authentication logic
  """
  alias Banking.{Repo, Guardian}
  alias Authentication.{User, Account, Encryptor, Credentials}

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

  @spec sign_in(credentials :: map()) ::
          {:ok, token() :: String.t()}
          | {:error, :malformed_credentials, Ecto.Changeset.t()}
          | {:error, :unauthorized}
  def sign_in(credentials) do
    changeset = Credentials.changeset(%Credentials{}, credentials)
    credentials = changeset.changes

    with %{valid?: true} <- changeset,
         account <- Repo.get_by(Account, email: credentials.email),
         true <- Encryptor.valid_password?(credentials.password, account.password),
         {:ok, token, _claims} <- Guardian.encode_and_sign(account, %{}) do
      {:ok, token}
    else
      %{valid?: false} -> {:error, :malformed_credentials, changeset}
      _any_other_case -> {:error, :unauthorized}
    end
  end
end
