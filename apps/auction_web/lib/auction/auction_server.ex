defmodule AuctionWeb.Auction.AuctionState do
  defstruct top_bid: %{bidder: nil, bid: 0},
            bidders: %{},
            bid_list: [],
            participants: %{},
            participant_count: 0,
            last_timer_id: nil,
            next_token_id: 1,
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

  def new_bid(server, token_id, bidder_name, bid, increase) do
    params = %{token_id: token_id, bidder_name: bidder_name, bid: bid, increase: increase}
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

  ## guards
  # defguard stale_token_id(token_id, %{next_token_id: next_token_id} = state) when token_id != next_token_id

  ## Server Callback
  def init(:ok) do
    new_state = %{
      top_bid: %{bidder: nil, bid: 0},
      bidders: %{},
      bid_list: [],
      participants: %{},
      participant_count: 0,
      next_token_id: 1,
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

  def handle_call({:bidder_join, bidder_name}, _from, state) do
    state =
      state
      |> add_bidder(bidder_name)

    Endpoint.broadcast!("auction:1", "bidder_join", push_back_state(state))

    {:reply, {:ok, state}, state}
  end

  def handle_call({:bid, %{token_id: token_id}}, _from, %{next_token_id: next_token_id} = state)
      when token_id != next_token_id do
    {:reply, {:error_stale_token_id, state}, state}
  end

  def handle_call(
        {:bid, %{bidder_name: bidder_name}},
        _from,
        %{top_bid: %{bidder: last_bider}} = state
      )
      when bidder_name == last_bider do
    {:reply, {:error_duplicated_bid, state}, state}
  end

  def handle_call({:bid, %{bid: bid}}, _from, %{top_bid: %{bid: last_bid}} = state)
      when bid != last_bid do
    {:reply, {:error_stale_bid, state}, state}
  end

  def handle_call({:bid, params}, _from, state) do
    token_id = params.token_id
    bidder_name = params.bidder_name
    bid = params.bid
    increase = params.increase
    new_bid = bid + increase

    state =
      state
      |> add_bidder(bidder_name)
      |> put_in([:top_bid, :bidder], bidder_name)
      |> put_in([:top_bid, :bid], new_bid)
      |> put_in([:participants, bidder_name, :bid], new_bid)
      |> put_in([:bidders, bidder_name], %{bid: new_bid})
      |> put_in([:next_token_id], state.next_token_id + 1)

    Endpoint.broadcast!("auction:1", "on_new_bid", push_back_state(state))
    {:reply, {:ok, state}, state}
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
