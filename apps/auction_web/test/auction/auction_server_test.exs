defmodule AuctionWeb.Auction.AuctionServerTest do
  use ExUnit.Case, async: true

  alias AuctionWeb.Auction.AuctionServer

  setup do
    {:ok, auction_server} = AuctionServer.start_link
    {:ok, server: auction_server}
  end

  describe "start on new auction" do
    test "bidder_join", %{server: server} do
      {:ok, auction_state} = AuctionServer.get_auction_state(server)
      assert get_in(auction_state, [:participants, "edwardzhou"]) == nil
      {:ok, state} = AuctionServer.bidder_join(server, "edwardzhou")
      assert get_in(state, [:participants, "edwardzhou"]) != nil
    end
  end
end