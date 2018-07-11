defmodule DB.Accounts.Authentication do
  @moduledoc """
  oauth授权认证信息
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias DB.Accounts.{Authentication, User}
  alias DB.Repo

  schema "authentications" do
    field(:email, :string)
    field(:image, :string)
    field(:name, :string)
    field(:nickname, :string)
    field(:provider, :string)
    field(:refresh_token, :string)
    field(:token, :string)
    field(:token_secret, :string)
    field(:uid, :string)
    field(:union_id, :string)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(%Authentication{} = authentication, attrs) do
    authentication
    |> cast(attrs, [
      :uid,
      :provider,
      :token,
      :refresh_token,
      :token_secret,
      :name,
      :nickname,
      :image,
      :union_id,
      :email,
      :user_id
    ])
    |> validate_required([:uid, :provider, :token])
    |> unsafe_validate_unique([:uid], Repo)
    |> unsafe_validate_unique([:email], Repo)
  end
end
