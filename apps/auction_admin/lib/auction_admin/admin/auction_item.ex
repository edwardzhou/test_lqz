defmodule AuctionAdmin.ExAdmin.AuctionItem do
  use ExAdmin.Register
  alias DB.Auctions.AuctionItem
  import AuctionAdmin.Gettext

  register_resource AuctionItem do
    menu label: gettext("Auction Items")

    form auction_item do
      inputs do
        input auction_item, :current_price, label: gettext("Current Price")
        input auction_item, :commission_rate, label: gettext("Commission Rate")
        input auction_item, :commission_amount, label: gettext("Commission Amount")
        input auction_item, :margin, label: gettext("Margin")
        input auction_item, :start_price, label: gettext("Start Price")
        input auction_item, :starts_at, type: DateTime, label: gettext("Starts At")
        input auction_item, :ends_at, type: DateTime, label: gettext("Ends At")
      end

    end
  end
end

