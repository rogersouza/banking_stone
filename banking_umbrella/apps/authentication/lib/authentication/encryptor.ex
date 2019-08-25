defmodule Authentication.Encryptor do
  @moduledoc """
  Conveniences to encrypt and check for password validity
  """

  alias Comeonin.Bcrypt

  def encrypt(password) do
    Bcrypt.hashpwsalt(password)
  end

  def valid_password?(password, hash) do
    Bcrypt.checkpw(password, hash)
  end
end
