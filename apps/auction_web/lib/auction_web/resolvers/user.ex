defmodule AuctionWeb.Resolvers.User do
  def get(_parent, args, _resolution) do
    {:ok, DB.Accounts.get_user!(args[:id])}
  end
end