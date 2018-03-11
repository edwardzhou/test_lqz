defmodule AuctionAdmin.ExAdmin.AuctionItem do
  use ExAdmin.Register
  alias DB.Auctions.AuctionItem
  register_resource AuctionItem do

    form auction_item do
      inputs do
        input auction_item, :current_price
        input auction_item, :commission_rate
        input auction_item, :commission_amount
        input auction_item, :margin
        input auction_item, :start_price
        input auction_item, :starts_at, type: DateTime
        input auction_item, :ends_at, type: DateTime
      end

    end
  end
end

