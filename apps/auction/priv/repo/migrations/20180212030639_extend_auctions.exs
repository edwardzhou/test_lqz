defmodule Auction.Repo.Migrations.ExtendAuctions do
  use Ecto.Migration

  def up do
    alter table(:auctions) do
      remove :product_name
      add :name, :string, comment: "拍卖专场名称"
      add :logo, :string, comment: "拍卖专场图片"
      add :starts_at, :utc_datetime, comment: "开始时间"
      add :ends_at, :utc_datetime, comment: "结束时间"
    end
  end

  def down do
    alter table(:auctions) do
      add :product_name, :string
      remove :name
      remove :logo
      remove :starts_at
      remove :ends_at
    end
  end
end
