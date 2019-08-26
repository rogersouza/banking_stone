defmodule Banking.Repo.Migrations.AddCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :email, :string, null: false
      add :name, :string, null: false
    end

    create unique_index(:customers, [:email])
  end
end
