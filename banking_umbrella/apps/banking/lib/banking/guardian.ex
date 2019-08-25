defmodule Banking.Guardian do
  use Guardian, otp_app: :banking

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    resource = Banking.Repo.get_by(Authentication.Account, id: id)
    {:ok, resource}
  end

  def resource_from_claims(_claims) do
    {:error, :sub_key_not_found}
  end
end
