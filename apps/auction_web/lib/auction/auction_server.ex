defmodule AuctionWeb.Auction.AuctionServer do
  use GenServer

  alias AuctionWeb.Auction.AuctionState
  alias AuctionWeb.Endpoint
  alias DB.Orders

  ## Client API

  @doc """
  Starts the auction_server.
  """
  def start_link(name \\ "") do
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

  def withdraw(server, token_id, bidder_name, bid) do
    params = %{
      token_id: token_id,
      bidder_name: bidder_name,
      bid: bid
    }

    GenServer.call(server, {:withdraw, params})
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
    new_state =
      AuctionState.new_state(1, 1000)
      |> AuctionState.start()

    Process.send_after(self(), {:timing}, 500)

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

    if ret == :ok do
      Endpoint.broadcast!(
        "auction:#{state.auction_id}",
        "on_new_bid",
        AuctionState.push_back_state(state)
      )
    end

    {:reply, {ret, state}, state}
  end

  def handle_call({:withdraw, params}, _from, state) do
    {ret, state} = AuctionState.withdraw(state, params)

    if ret == :ok do
      Endpoint.broadcast!(
        "auction:#{state.auction_id}",
        "on_withdraw",
        AuctionState.push_back_state(state)
      )
    end

    {:reply, {ret, state}, state}
  end

  def handle_call({:restart}, _from, state) do
    if state.last_timer_id != nil do
      Process.cancel_timer(state.last_timer_id)
    end

    state = AuctionState.new_state(state.auction_id, 1000) |> AuctionState.start()

    Endpoint.broadcast!(
      "auction:#{state.auction_id}",
      "on_restart",
      AuctionState.push_back_state(state)
    )

    {:reply, {:ok, state}, state}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_info({:timing}, state) do
    if AuctionState.is_on_going(state) do
      state = AuctionState.countdown(state)

      unless AuctionState.is_on_going(state) do
        IO.puts "Auction is closed."
        order = Orders.create_order_from_auction(state)
        IO.puts "Order: #{inspect(order)}"
      end
    end

    Process.send_after(self(), {:timing}, 500)
    {:noreply, state}
  end
end
