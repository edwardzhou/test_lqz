defmodule AuctionWeb.Resolvers.UserResolver do
  alias DB.Accounts
  def get(_parent, args, _resolution) do
    {:ok, Accounts.get_user!(args[:id])}
  end
end
