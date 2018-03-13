defmodule AuctionWeb.Schema do
  @moduledoc """
  GraphQL 模式定义
  """

  use AuctionWeb, :schema
  alias AuctionWeb.Resolvers.UserResolver
  alias DB.Repo
  alias DB.Auctions.Auction
  import Ecto.Query

  query name: "Query" do
    description("查询")

    field(:accounts_users, :accounts_user) do
      description("用户")
      arg(:id, non_null(:id), description: "用户ID")
      resolve(&UserResolver.get/3)
    end

    field(:auctions, list_of(:auction)) do
      description("拍卖场次")
      arg(:id, :id, description: "拍卖场次ID")
      resolve fn _, _ ->
        {:ok, Auction |> Repo.all}
      end
    end
  end

  # mutation name: "Mutations" do
  #   description("数据修改")

  # end
end
