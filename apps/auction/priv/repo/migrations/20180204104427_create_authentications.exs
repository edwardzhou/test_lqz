defmodule Auction.Repo.Migrations.CreateAuthentications do
  use Ecto.Migration

  def change do
    create table(:authentications) do
      add :uid, :string
      add :provider, :string
      add :token, :string
      add :refresh_token, :string
      add :token_secret, :string
      add :name, :string
      add :nickname, :string
      add :image, :string
      add :union_id, :string
      add :email, :string
      add :user_id, :integer

      timestamps()
    end

  end
end
