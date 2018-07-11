defmodule DB.Repo.Migrations.AddStateToAuction do
  use Ecto.Migration

  def change do
    alter table(:auctions) do
      add :state, :integer,
          default: 0,
          comment: "状态(0 - draft(草稿), 1 - ready(就绪), 2 - ongoing(拍卖中), 3 - ended(已结束)"
    end
  end
end
