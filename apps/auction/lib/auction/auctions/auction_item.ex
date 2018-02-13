defmodule Auction.Auctions.AuctionItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias Auction.Product
  alias Auction.Auctions.{AuctionItem, Auction}


  schema "auction_items" do
    field :current_price, :float
    field :default_raise, :float
    field :commission_rate, :float
    field :commission_amount, :float
    field :margin, :float
    field :start_price, :floatn
    field :start_at, :end_at, :naive_datetime
    field :end_at, :naive_datetime
    belongs_to :auction, Auction
    belongs_to :product, Product

    timestamps()
  end

  @doc false
  def changeset(%AuctionItem{} = auction_item, attrs) do
    auction_item
    |> cast(attrs, [:start_price, :start_at, :end_at, :current_price, :margin,
      :commission_rate, :commission_amount, :default_raise])
    |> validate_required([:start_price, :start_at, :end_at, :current_price, :margin,
      :commission_rate, :commission_amount, :default_raise])
  end
end
