defmodule DB.Accounts.RealnameVerification do
  @moduledoc """
  实名认证信息
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias DB.Repo
  alias DB.Accounts.User
  alias DB.Accounts.RealnameVerification

  schema "realname_verifications" do
    field(:realname, :string)
    field(:id_no, :string)
    field(:gender, :string)
    field(:birthday, :utc_datetime)
    field(:id_pic1, :string)
    field(:id_pic2, :string)
    field(:state, :integer)

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(%RealnameVerification{} = verification, attrs) do
    verification
    |> cast(attrs, [
      :realname,
      :id_no,
      :gender,
      :birthday,
      :id_pic1,
      :id_pic2,
      :state,
      :user_id
    ])
    |> validate_required([
      :realname,
      :id_no,
      :id_pic1,
      :id_pic2,
      :state,
      :user_id
    ])
    |> unsafe_validate_unique([:id_no], Repo)
    |> unsafe_validate_unique([:user_id], Repo)
  end
end
