defmodule DB.Repo.Migrations.ChangestatusToAuctionItem do
  use Ecto.Migration

  def up do
    alter table(:auction_items) do
      remove :state
      add :state, :integer, default: 0, comment: "状态(0 - 草稿, 1 - 就绪, 2 - 拍卖中, 3 - 流拍, 4 - 完成)"
    end
  end

  def down do
    alter table(:auction_items) do
      remove :state
      add :state, :string, default: "draft", comment: "状态(draft - 草稿, ready - 就绪, ongoing - 拍卖中, abandoned - 流拍, completed - 完成)"
    end
  end
end
