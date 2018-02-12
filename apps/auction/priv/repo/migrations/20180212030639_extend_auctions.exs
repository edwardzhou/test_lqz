defmodule Auction.Repo.Migrations.ExtendAuctions do
  use Ecto.Migration

  def up do
    alter table(:auctions) do
      remove :product_name
      add :auction_name, :string, comment: "拍卖专场名称"
      add :auction_img, :string, comment: "拍卖专场图片"
      add :start_at, :naive_datetime, comment: "开始时间"
      add :end_at, :naive_datetime, comment: "结束时间"
    end
  end

  def down do
    alter table(:auctions) do
      add :product_name, :string
      remove :auction_name
      remove :auction_img
      remove :start_at
      remove :end_at
    end
  end
end
