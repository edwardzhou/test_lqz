defmodule Auction.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :nickname, :string
      add :encrypted_password, :string
      add :telephone, :string
      add :email, :string

      timestamps()
    end

  end
end
