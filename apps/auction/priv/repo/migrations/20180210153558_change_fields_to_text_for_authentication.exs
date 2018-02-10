defmodule Auction.Repo.Migrations.ChangeFieldsToTextForAuthentication do
  use Ecto.Migration

  def change do
    alter table(:authentications) do
      modify :token, :text
    end
  end
end
