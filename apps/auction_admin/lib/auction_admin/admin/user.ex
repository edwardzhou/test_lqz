defmodule AuctionAdmin.ExAdmin.User do
  use ExAdmin.Register

  alias DB.Accounts.User

  register_resource User do
    scope :all, default: true
  end
end