defmodule AuctionWeb.AuctionControllerTest do
  use AuctionWeb.ConnCase

  alias Auction.Auctions

  @create_attrs %{product_name: "some product_name"}
  @update_attrs %{product_name: "some updated product_name"}
  @invalid_attrs %{product_name: nil}

  def fixture(:auction) do
    {:ok, auction} = Auctions.create_auction(@create_attrs)
    auction
  end

  defp create_auction(_) do
    auction = fixture(:auction)
    {:ok, auction: auction}
  end
end
