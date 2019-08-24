defmodule Authentication.Encryptor do
  @moduledoc """
  Conveniences to encrypt and check for password validity
  """

  def encrypt(password) do
    Base.encode32(password)
  end
end
