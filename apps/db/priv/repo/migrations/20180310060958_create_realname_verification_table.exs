defmodule DB.Repo.Migrations.CreateRealnameVerification do
  use Ecto.Migration

  def change do
    create table(:realname_verifications) do
      add :realname, :string, comment: "真实姓名"
      add :id_no, :string, comment: "身份证号"
      add :gender, :string, comment: "性别"
      add :birthday, :utc_datetime, comment: "生日"
      add :id_pic1, :string, comment: "身份证正面照片"
      add :id_pic2, :string, comment: "手持身份证照片"
      add :state , :integer, comment: "佣金金额"
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:realname_verifications, [:id_no], unique: true)
    create index(:realname_verifications, [:user_id], unique: true)
  end
end
