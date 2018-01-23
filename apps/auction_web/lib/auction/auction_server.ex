defmodule AuctionWeb.Auction.AuctionServer do
  use GenServer

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

  def shutdown() do
    GenServer.stop(__MODULE__, :normal)
  end

  ## Server Callback
  def init(:ok) do
    {:ok, %{top_bid: 0, bidders: %{}}}
  end

  def handle_call({:bidder_join, bidder_name}, _from, {top_bid, bidders}) do
    bidders = Map.put(bidders, bidder_name, %{bid: 0})
    {:reply, bidders, {top_bid, bidders}}
  end
end