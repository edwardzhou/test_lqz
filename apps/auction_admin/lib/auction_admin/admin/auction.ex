defmodule AuctionAdmin.ExAdmin.Auction do
  use ExAdmin.Register
  import AuctionAdmin.Gettext
  alias DB.Uploaders.Image
  alias DB.Auctions.Auction


  register_resource Auction do
    menu label: gettext("Auctions")

    index do
      column :id
      column :name, label: gettext("Auction Name")
      column :logo, [label: gettext("Auction Logo")], fn(auction) ->
        img src: Image.url(auction.logo, :thumb)
      end
      column :state, [label: gettext("State")], fn(auction) ->
        Auction.trans_state(auction.state)
      end
      column :starts_at, label: gettext("Starts At")
      column :ends_at, label: gettext("Ends At")
      actions()
    end

    show auction do
      attributes_table do
        row :id
        row :logo, [label: gettext("Auction Logo")], fn(auction) ->
          img src: Image.url(auction.logo, :thumb)
        end
        row :name, label: gettext("Auction Name")
        row :state, [label: gettext("State")], fn(auction) ->
          Auction.trans_state(auction.state)
        end
        row :starts_at, label: gettext("Starts At")
        row :ends_at, label: gettext("Ends At")
        row :inserted_at, label: gettext("Inserted At")
        row :updated_at, label: gettext("Updated At")
      end
    end

    form auction do
      inputs do
        input auction, :name, label: gettext("Auction Name")
        input auction, :logo, label: gettext("Auction Logo")
        input auction, :state, collection: Auction.states_with_trans, label: gettext("State")
        input auction, :starts_at, type: DateTime, label: gettext("Starts At")
        input auction, :ends_at, type: DateTime, label: gettext("Ends At")
      end
    end
  end
end

