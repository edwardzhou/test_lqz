defmodule AuctionWeb.Auction.AuctionRegistry do
  use GenServer

  alias AuctionWeb.Auction.AuctionServer

  ## API

  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def lookup(registry, auction_id) do
    GenServer.call(registry, {:lookup, auction_id})
  end

  def create(registry, auction_id) do
    GenServer.call(registry, {:create, auction_id})
  end

  ## Server callbacks
  def init(:ok) do
    names = %{}
    refs = %{}
    {:ok, {names, refs}}
  end

  def handle_call({:lookup, auction_id}, _from,  {names, refs} = state) do
    auction_key = "auction:#{auction_id}"

    response =
      case names[auction_key] do
        nil ->
          {:error, nil}

        auction ->
          {:ok, auction}
      end

    {:reply, response, state}
  end

  def handle_call({:create, auction_id}, _from, {names, refs} = state) do
    auction_key = "auction:#{auction_id}"

    case names[auction_key] do
      nil ->
        {:ok, server} = AuctionServer.start_link()

        ref = Process.monitor(server)
        refs = Map.put(refs, ref, auction_key)
        names = Map.put(names, auction_key, server)

        {:reply, {:ok, server}, {names, refs}}

      auction ->
        {:reply, {:ok, auction}, state}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs} = state) do
    {auction_key, refs} = Map.pop(refs, ref)
    names = Map.delete(names, auction_key)
    {:noreply, {names, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
