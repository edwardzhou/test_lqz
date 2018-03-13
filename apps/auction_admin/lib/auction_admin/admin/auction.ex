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
      column :starts_at, label: gettext "Starts At"
      column :ends_at, label: gettext("Ends At")
      actions()
    end

    show auction do
      attributes_table do
        row :id
        row :logo, fn(auction) -> img src: Image.url(auction.logo) end
        row :name
        row :starts_at
        row :ends_at
        row :inserted_at
        row :updated_at
      end
    end

    form auction do
      inputs do
        input auction, :name
        input auction, :logo
        input auction, :starts_at, type: DateTime
        input auction, :ends_at, type: DateTime
      end
    end
  end
end

