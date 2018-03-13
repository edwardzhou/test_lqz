defmodule AuctionWeb.Resolvers.UserResolver do
  @moduledoc """
  用户解释器
  """

  alias DB.Accounts

  @doc """
  根据 id 获取用户信息
  """
  def get(_parent, args, _resolution) do
    {:ok, Accounts.get_user(args[:id])}
  end
end
