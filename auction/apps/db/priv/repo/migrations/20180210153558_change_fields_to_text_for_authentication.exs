defmodule DB.Repo.Migrations.ChangeFieldsToTextForAuthentication do
  use Ecto.Migration

  def up do
    alter table(:authentications) do
      modify :token, :text
    end
  end

  def down do
    alter table(:authentications) do
      modify :token, :string
    end
  end
end
