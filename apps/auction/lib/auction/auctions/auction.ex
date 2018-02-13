defmodule Auction.Auctions.Auction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Auction.Auctions.Auction


  schema "auctions" do
    field :auction_name, :string
    field :auction_img, :string
    field :start_at, :naive_datetime, comment: "开始时间"
    field :end_at, :naive_datetime, comment: "结束时间"

    timestamps()
  end

  @doc false
  def changeset(%Auction{} = auction, attrs) do
    auction
    |> cast(attrs, [:auction_name, :auction_img, :start_at, :end_at])
    |> validate_required([:auction_name, :auction_img, :start_at, :end_at])
  end
end
