defmodule AuctionAdmin.ExAdmin.AuctionItem do
  use ExAdmin.Register
  alias DB.Auctions.AuctionItem
  import AuctionAdmin.Gettext
  alias DB.Auctions
  alias DB.Uploaders.Image


  register_resource AuctionItem do
    menu label: gettext("Auction Items")

    # query do
    #   %{
    #     all: [preload: [:auction]]
    #   }
    # end

    form auction_item do
      inputs do
        input auction_item, :title, label: gettext("Title")
        input auction_item, :item_logo, label: gettext("Item Logo")
        input auction_item, :current_price, label: gettext("Current Price")
        input auction_item, :commission_rate, label: gettext("Commission Rate")
        input auction_item, :commission_amount, label: gettext("Commission Amount")
        input auction_item, :margin, label: gettext("Margin")
        input auction_item, :start_price, label: gettext("Start Price")
        input auction_item, :grade, label: gettext("Grade")
        input auction_item, :description, label: gettext("Description")
        input auction_item, :specification, label: gettext("Specifiction")
        input auction_item, :auction, collection: Auctions.list_auctions
        input auction_item, :starts_at, type: DateTime, label: gettext("Starts At")
        input auction_item, :ends_at, type: DateTime, label: gettext("Ends At")
      end
    end

    show auction_item do
      attributes_table do
        row :id
        row :title
        row :item_logo, fn(item) -> 
          img src: Image.url(item.item_logo) 
        end
        row :auction
        row :seq_no
        row :state
        row :grade
        row :commission_rate
        row :commission_amount
        row :start_price
        row :current_price
        row :description
        row :specification
        row :starts_at
        row :ends_at
        row :inserted_at
        row :updated_at
      end
    end

  end
end

