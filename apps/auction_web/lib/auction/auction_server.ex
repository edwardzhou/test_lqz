defmodule AuctionWeb.Auction.AuctionState do
  defstruct top_bid: %{bidder: nil, bid: 0},
            bidders: %{},
            bid_list: [],
            participants: %{},
            participant_count: 0,
            last_timer_id: nil,
            countdown: 30

  def add_bidder(auction, bidder_name) do
    case Map.has_key?(auction.participants, bidder_name) do
      false ->
        auction
        |> Map.merge(%{participants: Map.put(auction.participants, bidder_name, %{bid: 0})})
        |> Map.merge(%{participant_count: auction.paritcipiant_count + 1})

      _ ->
        auction
    end
  end
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
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def bidder_join(server, bidder_name) do
    GenServer.call(server, {:bidder_join, bidder_name})
  end

  def new_bid(server, bidder_name, bid) do
    GenServer.call(server, {:bid, bidder_name, bid})
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

  # def handle_call({:bidder_join, bidder_name}, _from, state) do
  def handle_call({:bidder_join, bidder_name}, _from, state) do
    state =
      state
      |> add_bidder(bidder_name)

    Endpoint.broadcast!("auction:1", "bidder_join", push_back_state(state))

    {:reply, {:ok, state}, state}
  end

  def handle_call({:bid, bidder_name, bid}, _from, state) do
  # def handle_cast({:bid, bidder_name, bid}, state) do
    state =
      state
      |> add_bidder(bidder_name)
      |> put_in([:top_bid, :bidder], bidder_name)
      |> put_in([:top_bid, :bid], state.top_bid.bid + bid)
      |> put_in([:participants, bidder_name, :bid], bid)
      |> put_in([:bidders, bidder_name], %{bid: bid})

    Endpoint.broadcast!("auction:1", "on_new_bid", push_back_state(state))
    {:reply, state, state}
  end

  def handle_call({:restart}, _from, state) do
    if state.last_timer_id != nil do
      Process.cancel_timer(state.last_timer_id)
    end

    state =
      state
      |> put_in([:top_bid], %{bidder: nil, bid: 0})
      |> put_in([:bidders], %{})
      |> put_in([:bid_list], [])
      |> put_in([:countdown], 30)
      |> put_in([:participants], %{})
      |> put_in([:participant_count], 0)

    Endpoint.broadcast!("auction:1", "on_restart", push_back_state(state))

    {:reply, state, state}
  end

  def handle_info({:countdown, 0}, state) do
    Endpoint.broadcast!("auction:1", "bid_endded", %{})
    {:noreply, state}
  end

  def handle_info({:countdown, _counter}, state) do
    Process.cancel_timer(state.last_timer_id)
    Endpoint.broadcast!("auction:1", "countdown", %{counter: state.countdown})
    state = put_in(state.countdown, state.countdown - 1)
    timer_id = Process.send_after(self(), {:countdown, state.countdown}, 1000)
    state = put_in(state.last_timer_id, timer_id)

    {:noreply, state}
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, {:ok, state}, state}
  end
end
