defmodule Auction.Accounts.Authenticator do
  alias Auction.Accounts
  alias Auction.Accounts.Authentication

  def authenticate(%{} = _params) do
    Accounts.create_authentication(_params)
    # {:ok, %Authentication{}}
  end
end