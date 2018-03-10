defmodule AuctionWeb.Schema do
  use AuctionWeb, :schema
  # import_types(AuctionWeb.Types)

  query name: "Query" do
    field :accounts_users, list_of(:accounts_user) do
      arg(:id, non_null(:id))
      resolve &AuctionWeb.Resolvers.User.get/3
    end
  end
end