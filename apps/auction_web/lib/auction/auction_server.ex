defmodule AuctionWeb.Auction.AuctionState do
  defstruct top_bid: %{}, bidders: [], participants: %{}, participant_count: 0, last_timer_id: nil, countdown: 30
end

defmodule AuctionWeb.Auction.AuctionServer do
  use GenServer

  alias AuctionWeb.Auction.AuctionState

  ## Client API
  
  @doc """
  Starts the registry.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def bidder_join(bidder_name) do
    GenServer.call(__MODULE__, {:bidder_join, bidder_name})
  end

  def new_bid(bidder_name, bid) do
    GenServer.call(__MODULE__, {:bid, bidder_name, bid})
  end

  def shutdown() do
    GenServer.stop(__MODULE__, :normal)
  end

  def restart() do
    GenServer.call(__MODULE__, {:restart})
  end

  ## Server Callback
  def init(:ok) do
    new_state = %AuctionState{}

    {:ok, new_state }
  end

  def handle_call({:bidder_join, bidder_name}, _from, state) do
    if not Map.has_key?(state.participants, bidder_name) do
      state = put_in(state.participants[bidder_name], %{bid: 0})
      state = put_in(state.participant_count, Map.size(state.participants))
    end

    push_state = state 
    |> Map.delete(:last_timer_id)
    |> Map.delete(:participants)
    
    AuctionWeb.Endpoint.broadcast! "auction:1", "bidder_join", push_state

    {:reply, state, state}
  end

  def handle_call({:bid, bidder_name, bid}, _from, state) do
    if Map.has_key?(state.participants, bidder_name) do
      state = put_in(state.participants[bidder_name][:bid], bid)
      state = put_in(state.bidders, [%{bidder_name => %{bid: bid}} | state.bidders])
      state = put_in(state.top_bid, %{bidder: bidder_name, bid: bid})

      if state.last_timer_id != nil do
        :timer.cancel(state.last_timer_id)
        state = put_in(state.last_timer_id, nil)
        state = put_in(state.countdown, 30)
      end

      push_state = state 
                    |> Map.delete(:last_timer_id)
                    |> Map.delete(:participants)

      AuctionWeb.Endpoint.broadcast! "auction:1", "on_new_bid", push_state
      {:ok, timer_id} = :timer.send_after(100, {:countdown, state.countdown})
      state = put_in(state.last_timer_id, timer_id)  
      # state = put_in(state.last_timer_id, :timer.send_after(100, {:countdown, state.countdown}))
    end

    {:reply, state, state}
  end

  def handle_call({:restart}, _from, state) do
    state = put_in(state.top_bid, %{bidder: nil, bid: 0})
    state = put_in(state.bidder, [])
    {:reply, state, state}
  end

  def handle_info({:countdown, 0}, state) do
    AuctionWeb.Endpoint.broadcast! "auction:1", "bid_endded", %{}
    {:noreply, state}
  end
  def handle_info({:countdown, counter}, state) do
    AuctionWeb.Endpoint.broadcast! "auction:1", "countdown", %{counter: state.countdown}
    state = put_in(state.countdown, state.countdown - 1)
    {:ok, timer_id} = :timer.send_after(1000, {:countdown, state.countdown})
    state = put_in(state.last_timer_id, timer_id)

    {:noreply, state}
  end
end