defmodule AuctionWeb.Auction.AuctionSupervisor do
  use DynamicSupervisor

  alias AuctionWeb.Auction.AuctionServer

  ## Client API
  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_child(auction_key) do
    spec = Supervisor.Spec.worker(AuctionServer, [auction_key])
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  ## Server callbacks
  def init(:ok) do
    DynamicSupervisor.init(
      strategy: :one_for_one
    )
  end
end