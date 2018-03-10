defmodule AuctionWeb.Schema do
  use AuctionWeb, :schema
  alias AuctionWeb.Resolvers.UserResolver
  # import_types(AuctionWeb.Types)

  query name: "Query" do
    field :accounts_users, list_of(:accounts_user) do
      arg(:id, non_null(:id))
      resolve &UserResolver.get/3
    end
  end
end
