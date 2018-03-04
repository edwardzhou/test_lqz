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
      {:ok, state} = AuctionServer.new_bid(server, 1, "edwardzhou", 1000, 200)
      assert state.top_bid.bidder == "edwardzhou"
      assert state.top_bid.bid == 1200
      assert state.next_token_id == 2

      {:ok, state} = AuctionServer.new_bid(server, 2, "hero", 1200, 300)
      assert state.top_bid.bidder == "hero"
      assert state.top_bid.bid == 1500
      assert state.next_token_id == 3
    end

    test "stale token_id", %{server: server} do
      {:error_stale_token_id, state} = AuctionServer.new_bid(server, 2, "edwardzhou", 0, 300)
    end

    test "non-matched bid", %{server: server} do
      {:error_stale_bid, state} = AuctionServer.new_bid(server, 1, "edwardzhou", 0, 200)
    end

    test "duplicated bid", %{server: server} do
      {:ok, state} = AuctionServer.new_bid(server, 1, "edwardzhou", 1000, 200)
      {:error_duplicated_bid, state} = AuctionServer.new_bid(server, 2, "edwardzhou", 1200, 300)
    end
  end

  describe "withdraw" do
    test "bid", %{server: server} do
      {:ok, state} = AuctionServer.new_bid(server, 1, "edwardzhou", 1000, 100)
      assert state.top_bid.bidder == "edwardzhou"
      assert state.top_bid.bid == 1100
      assert state.next_token_id == 2
      {:ok, state} = AuctionServer.withdraw(server, 2, "edwardzhou", 1100)
    end
  end
end
