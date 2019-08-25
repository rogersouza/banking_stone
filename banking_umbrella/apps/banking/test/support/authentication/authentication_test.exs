defmodule Banking.AuthenticationTest do
  use Banking.DataCase

  alias Banking.Guardian

  @email "jane_doe@mail.com"
  @password "jane12345"

  @user_fixture %{
    "account" => %{
      "email" => @email,
      "password" => @password
    },
    "name" => "Jane Doe"
  }

  test "register/2 creates a new user" do
    assert {:ok, user} = Authentication.register(@user_fixture)
  end

  test "register/2 doesn't accept duplicated emails" do
    {:ok, _user} = Authentication.register(@user_fixture)
    {:error, changeset} = Authentication.register(@user_fixture)
    assert "has already been taken" in errors_on(changeset.changes.account).email
  end

  test "register/2 hashs the password" do
    {:ok, user} = Authentication.register(@user_fixture)
    plain_text_password = @user_fixture["account"]["password"]
    refute user.account.password == plain_text_password
  end

  test "register/2 rejects invalid emails" do
    account = %{"email" => "invalid_email.com", "password" => "123456"}
    user_fixture = %{@user_fixture | "account" => account}
    {:error, changeset} = Authentication.register(user_fixture)
    assert "has invalid format" in errors_on(changeset.changes.account).email
  end

  describe "sign_in/1" do
    setup do
      {:ok, _user} = Authentication.register(@user_fixture)
      :ok
    end

    test "returns {:ok, token} for valid credentials" do
      credentials = %{"email" => @email, "password" => @password}
      assert {:ok, token} = Authentication.sign_in(credentials)
      assert {:ok, _claims} = Guardian.decode_and_verify(token)
    end
  end
end
