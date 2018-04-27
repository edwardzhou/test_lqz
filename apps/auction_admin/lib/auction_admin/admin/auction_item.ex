defmodule AuctionAdmin.ExAdmin.AuctionItem do
  use ExAdmin.Register
  import AuctionAdmin.Gettext
  alias DB.Auctions.AuctionItem
  alias DB.Auctions
  alias DB.Products
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
        input auction_item, :auction, collection: Auctions.list_auctions, label: gettext("Auctions")
        input auction_item, :product, collection: Products.list_products, label: gettext("Products")
        input auction_item, :title, label: gettext("Title")
        input auction_item, :item_logo, label: gettext("Item Logo")
        input auction_item, :current_price, label: gettext("Current Price")
        input auction_item, :commission_rate, label: gettext("Commission Rate")
        input auction_item, :commission_amount, label: gettext("Commission Amount")
        input auction_item, :margin, label: gettext("Margin")
        input auction_item, :start_price, label: gettext("Start Price")
        input auction_item, :grade, label: gettext("Grade")
        input auction_item, :description, label: gettext("Description")
        input auction_item, :specification, label: gettext("Specification")
        input auction_item, :state, collection: AuctionItem.states_with_trans, label: gettext("State")
        input auction_item, :starts_at, type: DateTime, label: gettext("Starts At")
        input auction_item, :ends_at, type: DateTime, label: gettext("Ends At")
      end
    end

    index do
      column :id
      column :auction, label: gettext("Auctions")
      column :product, label: gettext("Products")
      column :title, label: gettext("Title")
      column :item_logo, [label: gettext("Auction Logo")], fn(item) ->
        img src: Image.url(item.item_logo, :thumb)
      end
      column :state, [label: gettext("State")], fn(item) ->
        AuctionItem.trans_state(item.state)
      end
      column :starts_at, label: gettext("Starts At")
      column :ends_at, label: gettext("Ends At")
      actions()
    end

    show auction_item do
      attributes_table do
        row :id
        row :title, label: gettext("Title")
        row :item_logo, [label: gettext("Auction Logo")], fn(item) ->
          img src: Image.url(item.item_logo) 
        end
        row :auction, label: gettext("Auctions")
        row :product, label: gettext("Products")
        row :seq_no
        row :state, [label: gettext("State")], fn(item) ->
          AuctionItem.trans_state(item.state)
        end
        row :grade, label: gettext("Grade")
        row :commission_rate, label: gettext("Commission Rate")
        row :commission_amount, label: gettext("Commission Amount")
        row :start_price, label: gettext("Start Price")
        row :current_price, label: gettext("Current Price")
        row :description, label: gettext("Description")
        row :specification, label: gettext("Specification")
        row :starts_at, label: gettext("Starts At")
        row :ends_at, label: gettext("Ends At")
        row :inserted_at, label: gettext("Inserted At")
        row :updated_at, label: gettext("Updated At")
      end
    end
  end
end

