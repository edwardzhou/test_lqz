defmodule AuctionWeb.Auction.AuctionStateTest do
  use ExUnit.Case, async: true

  alias AuctionWeb.Auction.AuctionState

  setup do
    state = AuctionState.new_state(1, 1000)
    {:ok, state: state}
  end

  describe "#add_bidder" do
    test "new bidder", %{state: state} do
      state = state |> AuctionState.add_bidder("user1")
      assert state.participants["user1"] != nil
      assert state.participant_count == 1
    end

    test "duplicated bidder", %{state: state} do
      state = state |> AuctionState.add_bidder("user1")
      state = state |> AuctionState.add_bidder("user1")
      assert state.participants["user1"] != nil
      assert state.participant_count == 1
    end

    test "more bidders", %{state: state} do
      state = state |> AuctionState.add_bidder("user1")
      state = state |> AuctionState.add_bidder("user2")
      assert state.participants["user1"] != nil
      assert state.participants["user2"] != nil
      assert state.participant_count == 2
    end
  end

  describe "#bid" do
    test "staled token_id", %{state: state} do
      params = %{
        token_id: 0,
        bidder_name: "user1",
        bid_base: 1000,
        increase: 100
      }

      {:error_stale_token_id, _} = state |> AuctionState.bid(params)
    end

    test "staled bid base", %{state: state} do
      params = %{
        token_id: 1,
        bidder_name: "user1",
        bid_base: 100,
        increase: 100
      }

      {:error_stale_bid, _} = state |> AuctionState.bid(params)
    end

    test "duplicated bid", %{state: state} do
      state = %{
        state | next_token_id: 2, top_bid: %{bidder: "user1", bid: 1000}
      }
      params = %{
        token_id: 2,
        bidder_name: "user1",
        bid_base: 1000,
        increase: 100
      }
      {:error_duplicated_bid, _} = state |> AuctionState.bid(params)
    end

    test "successful", %{state: state} do
      params = %{
        token_id: 1,
        bidder_name: "user1",
        bid_base: 1000,
        increase: 100
      }
      {:ok, state} = state |> AuctionState.bid(params)
      assert state.next_token_id == 2
      assert state.top_bid.bidder == "user1"
      assert state.top_bid.bid == 1100
      assert state.increases == [150, 300, 750]
      assert state.participants["user1"] != nil
      assert state.bidders["user1"] != nil
      assert List.first(state.bid_list)[:bidder] == "user1"
      assert List.first(state.bid_list)[:bid] == 1100
    end

    test "multiple successful", %{state: state} do
      params = %{
        token_id: 1,
        bidder_name: "user1",
        bid_base: 1000,
        increase: 100
      }
      {:ok, state} = state |> AuctionState.bid(params)
      params = %{
        params | 
        token_id: 2,
        bidder_name: "user2",
        bid_base: 1100,
        increase: 300
      }
      {:ok, state} = state |> AuctionState.bid(params)
      assert state.next_token_id == 3
      assert state.top_bid.bidder == "user2"
      assert state.top_bid.bid == 1400
    end

  end
end
