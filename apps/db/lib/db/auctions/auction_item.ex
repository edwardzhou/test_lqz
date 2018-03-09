defmodule DB.Auctions.AuctionItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias DB.Product
  alias DB.Auctions.{AuctionItem, Auction}

  schema "auction_items" do
    field :current_price, :decimal
    field :commission_rate, :decimal
    field :commission_amount, :decimal
    field :margin, :decimal
    field :start_price, :decimal
    field :starts_at, :utc_datetime
    field :ends_at, :utc_datetime
    belongs_to :auction, Auction
    belongs_to :product, Product

    timestamps()
  end

  @doc false
  def changeset(%AuctionItem{} = auction_item, attrs) do
    auction_item
    |> cast(attrs, [:start_price, :starts_at, :ends_at, :current_price, :margin,
      :commission_rate, :commission_amount])
    |> validate_required([:start_price, :starts_at, :ends_at, :current_price, :margin,
      :commission_rate, :commission_amount])
  end
end
