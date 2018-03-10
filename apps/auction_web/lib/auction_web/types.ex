defmodule AuctionWeb.Types do
  @moduledoc """
  GraphQL 类型
  """

  use AuctionWeb, :type
  import Ecto.Query
  use Absinthe.Ecto, repo: DB.Repo

  object :accounts_user do
    description("用户信息")

    field(:id, :id) do
      description("用户ID")
    end

    field(:nickname, :string) do
      description("用户昵称")
    end

    field(:username, :string) do
      description("用户登录名")
    end

    field(:telephone, :string) do
      description("手机号码")
    end

    field(:authentications, list_of(:authentication)) do
      resolve(assoc(:authentications))
      description("oauth认证授权")
    end
  end

  object :authentication do
    field(:id, :id)
    field(:uid, :string)
    field(:email, :string)
    field(:image, :string)
    field(:name, :string)
    field(:nickname, :string)
    field(:provider, :string)
    field(:refresh_token, :string)
    field(:token, :string)
    field(:token_secret, :string)
    field(:user, :accounts_user, resolve: assoc(:user))
  end
end
