defmodule Banking.Repo.Migrations.AddTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :integer, null: false
      add :customer_id, references(:customers), null: false
      add :destination_customer_id, references(:customers), null: true
      add :type, :string, null: false

      timestamps()
    end
  end
end
