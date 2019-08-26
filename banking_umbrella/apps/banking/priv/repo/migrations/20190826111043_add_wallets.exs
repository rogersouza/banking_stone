defmodule Banking.Repo.Migrations.AddWallets do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add :customer_id, references(:customers)
      add :balance, :integer
    end
  end
end
