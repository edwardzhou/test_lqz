defmodule AuctionAdmin.ExAdmin.Authentication do
  use ExAdmin.Register

  alias Auction.Accounts.Authentication

  register_resource Authentication do
    scope :all, default: true

  end
end
