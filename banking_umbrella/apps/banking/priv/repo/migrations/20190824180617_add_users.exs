defmodule Banking.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :account_id, references(:accounts), null: false
      add :name, :string, null: false
    end
  end
end
