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
      assert auction_state.participants["edwardzhou"] == nil
      {:ok, state} = AuctionServer.bidder_join(server, "edwardzhou")
      assert state.participants["edwardzhou"] != nil
    end
  end

  describe "bidding" do
    test "bid", %{server: server} do
      {:ok, state} = AuctionServer.new_bid(server, 1, "edwardzhou", 0, 300)
      assert state.top_bid.bidder == "edwardzhou"
      assert state.top_bid.bid == 300
      assert state.next_token_id == 2

      {:ok, state} = AuctionServer.new_bid(server, 2, "hero", 300, 500)
      assert state.top_bid.bidder == "hero"
      assert state.top_bid.bid == 800
      assert state.next_token_id == 3
    end

    test "stale token_id", %{server: server} do
      {:error_stale_token_id, state} = AuctionServer.new_bid(server, 2, "edwardzhou", 0, 300)
    end

    test "non-matched bid", %{server: server} do
      {:error_stale_bid, state} = AuctionServer.new_bid(server, 1, "edwardzhou", 1000, 200)
    end

    test "duplicated bid", %{server: server} do
      {:ok, state} = AuctionServer.new_bid(server, 1, "edwardzhou", 0, 200)
      {:error_duplicated_bid, state} = AuctionServer.new_bid(server, 2, "edwardzhou", 200, 300)
    end
  end
end
