defmodule DB.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :price, :decimal, comment: "价格"
      add :specification, :string, comment: "拍品规格"
      add :grade, :string, comment: "品相等级"
      add :description, :text
      timestamps()
    end

  end
end
