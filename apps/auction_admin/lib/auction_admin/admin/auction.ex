defmodule AuctionAdmin.ExAdmin.Auction do
  use ExAdmin.Register
  alias Auction.Uploaders.Image
  alias Auction.Auctions.Auction
  register_resource Auction do

    index do
      column :id
      column :logo, fn(auction) ->
        img src: Image.url(auction.logo, :thumb)
      end
      column :starts_at
      column :ends_at
      actions()
    end

    show auction do
      attributes_table do
        row :id
        row :name
        row :logo, fn(auction) -> img src: Image.url(auction.logo) end
        row :starts_at
        row :ends_at
        row :inserted_at
        row :updated_at
      end
    end

    form auction do
      inputs do
        input auction, :name, prompt: "测试"
        input auction, :logo
        input auction, :starts_at, type: DateTime
        input auction, :ends_at, type: DateTime
      end
    end
  end
end

