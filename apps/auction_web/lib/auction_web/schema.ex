defmodule AuctionWeb.Schema do
  @moduledoc """
  GraphQL 模式定义
  """

  use AuctionWeb, :schema
  alias AuctionWeb.Resolvers.UserResolver

  query name: "Query" do
    description("查询")

    field(:accounts_users, list_of(:accounts_user)) do
      description("获取用户")
      arg(:id, non_null(:id), description: "用户ID") 
      resolve(&UserResolver.get/3)
    end
  end
end
