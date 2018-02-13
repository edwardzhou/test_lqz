defmodule Auction.Repo.Migrations.CreateAuctionItems do
  use Ecto.Migration

  def change do
    create table(:auction_items) do
      add :start_price, :decimal, comment: "起拍价格"
      add :starts_at, :utc_datetime, comment: "起拍时间"
      add :ends_at, :utc_datetime, comment: "结束时间"
      add :current_price, :decimal, comment: "当前价格"
      add :margin, :decimal, comment: "保证金"
      add :commission_rate , :decimal, comment: "佣金比例"
      add :commission_amount , :decimal, comment: "佣金金额"
      add :auction_id, references(:auctions, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)

      timestamps()
    end

    create index(:auction_items, [:auction_id])
    create index(:auction_items, [:product_id])
  end
end
