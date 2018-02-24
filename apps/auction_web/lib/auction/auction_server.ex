defmodule AuctionWeb.Auction.AuctionServer do
  use GenServer

  alias AuctionWeb.Auction.AuctionState
  alias AuctionWeb.Endpoint

  ## Client API

  @doc """
  Starts the auction_server.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def bidder_join(server, bidder_name) do
    GenServer.call(server, {:bidder_join, bidder_name})
  end

  def new_bid(server, token_id, bidder_name, bid, increase) do
    params = %{
      token_id: token_id,
      bidder_name: bidder_name,
      bid_base: bid,
      increase: increase
    }

    GenServer.call(server, {:bid, params})
  end

  def shutdown(server) do
    GenServer.stop(server, :normal)
  end

  def restart(server) do
    GenServer.call(server, {:restart})
  end

  def get_auction_state(server) do
    GenServer.call(server, {:get_state})
  end

  ## Server Callback
  def init(:ok) do
    new_state = %AuctionState{}

    {:ok, new_state}
  end

  def handle_call({:bidder_join, bidder_name}, _from, state) do
    state =
      state
      |> AuctionState.add_bidder(bidder_name)

    Endpoint.broadcast!(
      "auction:#{state.auction_id}",
      "bidder_join",
      AuctionState.push_back_state(state)
    )

    {:reply, {:ok, state}, state}
  end

  def handle_call({:bid, params}, _from, state) do
    {ret, state} = AuctionState.bid(state, params)

    Endpoint.broadcast!(
      "auction:#{state.auction_id}",
      "on_new_bid",
      AuctionState.push_back_state(state)
    )

    {:reply, {ret, state}, state}
  end

  def handle_call({:restart}, _from, state) do
    if state.last_timer_id != nil do
      Process.cancel_timer(state.last_timer_id)
    end

    state = %AuctionState{}

    Endpoint.broadcast!(
      "auction:#{state.auction_id}",
      "on_restart",
      AuctionState.push_back_state(state)
    )

    {:reply, state, state}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, {:ok, state}, state}
  end
end
