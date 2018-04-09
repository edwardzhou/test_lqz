defmodule DB.Repo.Migrations.AddFieldsToAuctionItems do
  use Ecto.Migration

  def up do
    alter table(:auction_items) do
      add :title, :string, comment: "拍品名称"
      add :state, :string, default: "draft", comment: "状态(draft - 草稿, ready - 就绪, ongoing - 拍卖中, abandoned - 流拍, completed - 完成)"
      add :seq_no, :integer, default: 0, comment: "拍卖顺序"
      add :item_logo, :string, comment: "拍卖项logo"
      add :grade, :string, comment: "拍品等级"
      add :price, :decimal, comment: "拍品单价"
      add :description, :text, comment: "描述"
      add :specification, :text, comment: "拍品规格"
    end
  end

  def down do
    alter table(:auction_items) do
      remove :description
      remove :item_logo
      remove :seq_no
      remove :state
      remove :title
      remove :grade
      remove :price
      remove :specification
    end
  end

end
