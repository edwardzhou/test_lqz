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

    field(:email, :string) do
      description("邮箱")
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

  object :auction do
    filed(:id, :id)

    field(:name, :string) do
      description("场次名称")
    end

    field(:logo, :string) do
      description("logo")

      resolve fn auction, _, _ ->
        {:ok, DB.Uploaders.Image.url(auction.logo)}
      end
    end

    field(:starts_at, :datetime) do
      description("拍卖开始时间")
    end

    field(:ends_at, :datetime) do
      description("拍卖结束时间")
    end

    field(:auction_items, list_of(:auction_item)) do
      resolve(assoc(:auction_items))
      description("拍卖单品列表")
    end
  end

  object :auction_item do
    field(:id, :id)

    field(:current_price, :decimal) do
      description("当前应价")
    end

    field(:start_price, :decimal) do
      description("起拍价")
    end

    field(:starts_at, :datetime) do
      description("拍卖开始时间")
    end

    field(:margin, :decimal) do
    end

    field(:commission_rate, :decimal) do
      description("佣金比例")
    end

    field(:commission_amount, :decimal) do
      description("佣金")
    end

    field(:auction, :auction, resolve: assoc(:auction))
    field(:product, :product, resolve: assoc(:product))
  end

  object :product do
    description("商品信息")

    field(:description, :string) do
      description("描述")
    end

    field(:grade, :string) do
      description("品相等级")
    end

    field(:name, :string) do
      description("商品名称")
    end

    field(:price, :decimal) do
      description("单价")
    end

    field(:specification, :string) do
      description("拍品规格")
    end
  end
end
