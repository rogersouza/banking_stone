defmodule Authentication.Repo.Migrations.AddAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :email, :string, null: false
      add :password, :string, null: false
    end

    create unique_index(:accounts, [:email])
  end
end
