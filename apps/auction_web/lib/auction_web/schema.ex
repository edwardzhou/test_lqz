defmodule AuctionWeb.Schema do
  @moduledoc """
  GraphQL 模式定义
  """

  use AuctionWeb, :schema
  alias AuctionWeb.Resolvers.UserResolver

  query name: "Query" do
    field :accounts_users, list_of(:accounts_user) do
      arg(:id, non_null(:id))
      resolve &UserResolver.get/3
    end
  end
end
