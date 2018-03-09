defmodule AuctionAdmin.ExAdmin.Authentication do
  use ExAdmin.Register

  alias DB.Accounts.Authentication

  register_resource Authentication do
    scope :all, default: true

  end
end
