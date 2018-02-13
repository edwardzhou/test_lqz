defmodule Auction.Repo.Migrations.CreateAuctionItems do
  use Ecto.Migration

  def change do
    create table(:auction_items) do
      add :start_price, :float, comment: "起拍价格"
      add :start_at, :naive_datetime, comment: "起拍时间"
      add :end_at, :naive_datetime, comment: "结束时间"
      add :current_price, :float, comment: "当前价格"
      add :margin, :float, comment: "保证金"
      add :commission_rate , :float, comment: "佣金比例"
      add :commission_amount , :float, comment: "佣金金额"
      add :default_raise, :float, comment: "默认加价幅度"
      add :auction_id, references(:auctions, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)

      timestamps()
    end

    create index(:auction_items, [:auction_id])
    create index(:auction_items, [:product_id])
  end
end
