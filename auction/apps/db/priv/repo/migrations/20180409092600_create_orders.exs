defmodule Db.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :user_id, :integer
      add :auction_item_id, :integer
      add :auction_id, :integer
      add :amount, :decimal
      add :commission_rate, :decimal
      add :commission_amount, :decimal
      add :state, :string
      add :memo, :text
      add :paid_at, :utc_datetime
      add :payment_id, :integer
      add :shipped_at, :utc_datetime
      add :completed_at, :utc_datetime
      add :cancelled_at, :utc_datetime
      add :returned_at, :utc_datetime

      timestamps()
    end

    create index(:orders, [:auction_id])
    create index(:orders, [:auction_item_id])
    create index(:orders, [:payment_id])
    create index(:orders, [:user_id])

  end
end
