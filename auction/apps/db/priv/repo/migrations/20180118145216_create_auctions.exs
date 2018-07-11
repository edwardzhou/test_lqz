defmodule DB.Repo.Migrations.CreateAuctions do
  use Ecto.Migration

  def change do
    create table(:auctions) do
      add :product_name, :string

      timestamps()
    end

  end
end
