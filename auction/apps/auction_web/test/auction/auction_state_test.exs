defmodule AuctionWeb.Auction.AuctionStateTest do
  use ExUnit.Case, async: true

  alias AuctionWeb.Auction.AuctionState

  setup do
    state = AuctionState.new_state(1, 1000) |> AuctionState.start()
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
        state
        | next_token_id: 2,
          top_bid: %{bidder: "user1", bid: 1000}
      }

      params = %{
        token_id: 2,
        bidder_name: "user1",
        bid_base: 1000,
        increase: 100
      }

      {:error_duplicated_bid, _} = state |> AuctionState.bid(params)
    end

    test "not on_going", %{state: state} do
      state = %{
        state
        | status: :closed
      }

      params = %{
        token_id: 1,
        bidder_name: "user1",
        bid_base: 1000,
        increase: 100
      }

      {:error_closed, state} = state |> AuctionState.bid(params)
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
      assert state.increases == [20, 100, 200]
      assert state.participants["user1"] != nil
      assert state.bidders["user1"] != nil
      assert List.first(state.bid_list)[:bidder] == "user1"
      assert List.first(state.bid_list)[:bid] == 1100
    end

    test "sequentially success", %{state: state} do
      params = %{
        token_id: 1,
        bidder_name: "user1",
        bid_base: 1000,
        increase: 100
      }

      {:ok, state} = state |> AuctionState.bid(params)

      params = %{params | token_id: 2}
      params = %{params | bidder_name: "user2"}
      params = %{params | bid_base: 1100}
      params = %{params | increase: 200}

      {:ok, state} = state |> AuctionState.bid(params)
      assert state.next_token_id == 3
      assert state.top_bid.bidder == "user2"
      assert state.top_bid.bid == 1300
    end
  end

  describe "#update_increases" do
    test "top_bid is nil" do
      state = AuctionState.new_state(1, 1000) |> AuctionState.start()
      assert state.increases == [20, 100, 200]
    end

    test "top_bid < 2000" do
      state = AuctionState.new_state(1, 1000) |> AuctionState.start()
      params = %{
        token_id: 1,
        bidder_name: "user1",
        bid_base: 1000,
        increase: 100
      }
      {:ok, state} = state |> AuctionState.bid(params)
      assert state.top_bid.bid == 1100
      assert state.increases == [20, 100, 200]
    end

    test "top_bid = 3000" do
      state = AuctionState.new_state(1, 3000) |> AuctionState.start()
      assert state.increases == [50, 200, 500]

      state = AuctionState.new_state(1, 6000) |> AuctionState.start()
      assert state.increases == [100, 500, 1_000]

      state = AuctionState.new_state(1, 20_000) |> AuctionState.start()
      assert state.increases == [200, 1_000, 2_000]

      state = AuctionState.new_state(1, 60_000) |> AuctionState.start()
      assert state.increases == [500, 2_000, 5_000]

      state = AuctionState.new_state(1, 300_000) |> AuctionState.start()
      assert state.increases == [1_000, 5_000, 10_000]
    end
  end

  describe "#withdraw" do
    test "staled token_id", %{state: state} do
      state = %{state | top_bid: %{bidder: "user1", bid: 2500}}
      state = %{state | bid_list: [
        %{bidder: "user1", bid: 2500}
      ]}
      state = %{state | next_token_id: 2}

      params = %{
        token_id: 1,
        bidder_name: "user1",
        bid: 2500
      }

      {:error, new_state} = state |> AuctionState.withdraw(params)
      assert new_state.top_bid.bidder == "user1"
      assert new_state.top_bid.bid == 2500
      [%{bidder: "user1", bid: 2500} | _] = new_state.bid_list
      assert new_state.next_token_id == 2
    end

    test "empty bids", %{state: state} do
      state = %{state | top_bid: %{bidder: "user1", bid: 2500}}
      state = %{state | bid_list: []}
      state = %{state | next_token_id: 1}

      params = %{
        token_id: 1,
        bidder_name: "user1",
        bid: 2500
      }

      {:error, new_state} = state |> AuctionState.withdraw(params)
    end

    test "shouldn't withdraw on unmatched bid", %{state: state} do
      state = %{state | top_bid: %{bidder: "user1", bid: 2500}}
      state = %{state | bid_list: [
        %{bidder: "user1", bid: 2500}
      ]}
      state = %{state | next_token_id: 2}

      params = %{
        token_id: 2,
        bidder_name: "user1",
        bid: 2000
      }

      {:error, new_state} = state |> AuctionState.withdraw(params)
      assert new_state.top_bid.bidder == "user1"
      assert new_state.top_bid.bid == 2500
      [%{bidder: "user1", bid: 2500} | _] = new_state.bid_list
      assert new_state.next_token_id == 2
    end

    test "shouldn't withdraw other's bid", %{state: state} do
      state = %{state | top_bid: %{bidder: "user1", bid: 2500}}
      state = %{state | bid_list: [
        %{bidder: "user1", bid: 2500}
      ]}
      state = %{state | next_token_id: 2}

      params = %{
        token_id: 2,
        bidder_name: "user2",
        bid: 2500
      }

      {:error, new_state} = state |> AuctionState.withdraw(params)
      assert new_state.top_bid.bidder == "user1"
      assert new_state.top_bid.bid == 2500
      [%{bidder: "user1", bid: 2500} | _] = new_state.bid_list
      assert new_state.next_token_id == 2
    end

    test "timeout > 10 seconds", %{state: state} do
      state = %{state | top_bid: %{bidder: "user1", bid: 2500}}
      state = %{state | bid_list: [
        %{bidder: "user1", bid: 2500}
      ]}
      state = %{state | next_token_id: 2}
      state = %{state | bid_at: Timex.local() |> Timex.shift(seconds: -10) }

      params = %{
        token_id: 2,
        bidder_name: "user1",
        bid: 2500
      }

      {:error, new_state} = state |> AuctionState.withdraw(params)
    end

    test "can only withdraw once", %{state: state} do
      state = %{state | top_bid: %{bidder: "user1", bid: 2500}}
      state = %{state | bid_list: [
        %{bidder: "user1", bid: 2500}
      ]}
      state = %{state | next_token_id: 2}
      state = %{state | withdraws: %{"user1" => %{bid: 2500, token_id: 1}} }

      params = %{
        token_id: 2,
        bidder_name: "user1",
        bid: 2500
      }

      {:error_withdraw_once, new_state} = state |> AuctionState.withdraw(params)
    end

    test "success with first bids", %{state: state} do
      state = %{state | top_bid: %{bidder: "user1", bid: 2500}}
      state = %{state | bid_list: [
        %{bidder: "user1", bid: 2500}
      ]}
      state = %{state | next_token_id: 2}

      params = %{
        token_id: 2,
        bidder_name: "user1",
        bid: 2500
      }

      {:ok, new_state} = state |> AuctionState.withdraw(params)
      assert new_state.top_bid.bidder == nil
      assert new_state.top_bid.bid == new_state.price_starts
      [%{bidder: "user1", bid: -2500} | _] = new_state.bid_list
      assert new_state.next_token_id == 3
    end

    test "success with more than 2 bids", %{state: state} do
      state = %{state | top_bid: %{bidder: "user1", bid: 2500}}
      state = %{state | bid_list: [
        %{bidder: "user1", bid: 2500}, 
        %{bidder: "user2", bid: 1500}
      ]}
      state = %{state | next_token_id: 3}

      params = %{
        token_id: 3,
        bidder_name: "user1",
        bid: 2500
      }

      {:ok, new_state} = state |> AuctionState.withdraw(params)
      assert new_state.top_bid.bidder == "user2"
      assert new_state.top_bid.bid == 1500
      [%{bidder: "user1", bid: -2500} | _] = new_state.bid_list
      assert new_state.next_token_id == 4
    end
  end
end
