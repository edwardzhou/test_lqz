defmodule AuctionWeb.Auction.AuctionState do
  defstruct top_bid: %{bidder: nil, bid: 0}, 
            bidders: %{},
            bid_list: [], 
            participants: %{}, 
            participant_count: 0, 
            last_timer_id: nil, 
            countdown: 30
end

defmodule AuctionWeb.Auction.AuctionServer do
  use GenServer

  alias AuctionWeb.Auction.AuctionState
  alias AuctionWeb.Endpoint

  ## Client API
  
  @doc """
  Starts the registry.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def bidder_join(bidder_name) do
    GenServer.cast(__MODULE__, {:bidder_join, bidder_name})
  end

  def new_bid(bidder_name, bid) do
    GenServer.cast(__MODULE__, {:bid, bidder_name, bid})
  end

  def shutdown() do
    GenServer.stop(__MODULE__, :normal)
  end

  def restart() do
    GenServer.call(__MODULE__, {:restart})
  end

  ## Server Callback
  def init(:ok) do
    new_state = %{
      top_bid: %{bidder: nil, bid: 0},
      bidders: %{},
      bid_list: [],
      participants: %{},
      participant_count: 0,
      last_timer_id: nil,
      countdown: 30
    }

    {:ok, new_state}
  end

  defp update_participant_count(state) do
    state
    |> put_in([:participant_count], Map.size(state.participants))
  end

  defp push_back_state(state) do
    state
    |> Map.delete(:last_timer_id)
    |> Map.delete(:participants)
  end

  defp add_bidder(state, bidder_name) do
    case Map.has_key?(state.participants, bidder_name) do
      false ->
        state
        |> put_in([:participants, bidder_name], %{bid: 0})
        |> update_participant_count()
      _ ->
        state
    end
  end

  #def handle_call({:bidder_join, bidder_name}, _from, state) do
  def handle_cast({:bidder_join, bidder_name}, state) do
    state = state
            |> add_bidder(bidder_name)
    Endpoint.broadcast! "auction:1", "bidder_join", push_back_state(state)

    {:noreply, state}
  end

  # def handle_call({:bid, bidder_name, bid}, _from, state) do
  def handle_cast({:bid, bidder_name, bid}, state) do
    state = state
            |> add_bidder(bidder_name)
            |> put_in([:top_bid, :bidder], bidder_name)
            |> put_in([:top_bid, :bid], state.top_bid.bid + bid)
            |> put_in([:participants, bidder_name, :bid], bid)
            |> put_in([:bidders, bidder_name], %{bid: bid})

    Endpoint.broadcast! "auction:1", "on_new_bid", push_back_state(state)

    {:noreply, state}
  end

  def handle_call({:restart}, _from, state) do
    if state.last_timer_id != nil do
      Process.cancel_timer(state.last_timer_id)
    end

    state = state
            |> put_in([:top_bid], %{bidder: nil, bid: 0})
            |> put_in([:bidders], %{})
            |> put_in([:bid_list], [])
            |> put_in([:countdown], 30)
            |> put_in([:participants], %{})
            |> put_in([:participant_count], 0)

    Endpoint.broadcast! "auction:1", "on_restart", push_back_state(state)
  
    {:reply, state, state}
  end

  def handle_info({:countdown, 0}, state) do
    Endpoint.broadcast! "auction:1", "bid_endded", %{}
    {:noreply, state}
  end
  def handle_info({:countdown, _counter}, state) do
    Process.cancel_timer(state.last_timer_id)
    Endpoint.broadcast! "auction:1", "countdown", %{counter: state.countdown}
    state = put_in(state.countdown, state.countdown - 1)
    timer_id = Process.send_after(self(), {:countdown, state.countdown}, 1000)
    state = put_in(state.last_timer_id, timer_id)

    {:noreply, state}
  end
end