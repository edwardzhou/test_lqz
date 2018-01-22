defmodule Auction.Auctions.Auction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Auction.Auctions.Auction


  schema "auctions" do
    field :product_name, :string

    timestamps()
  end

  @doc false
  def changeset(%Auction{} = auction, attrs) do
    auction
    |> cast(attrs, [:product_name])
    |> validate_required([:product_name])
  end
end
