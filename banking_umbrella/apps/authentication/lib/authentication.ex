defmodule Authentication do
  @moduledoc """
  Holds all the authentication logic
  """
  alias Authentication.{Repo, Guardian}
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

  @doc """
  Returns a JWT if the credentials are valid

  ### Example 
  iex> credentials = %{"email" => "mail@mail.com", "password" => "123456"}
  iex> case Authentication.sign_in(credentials) do
         {:ok, token} -> # Credentials are valid
         {:error, :unauthorized} -> # Invalid password/email
         {:error, :malformed_credentials, changeset} -> # Malformed credentials
       end
  """
  @spec sign_in(map()) ::
          {:ok, String.t()}
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
