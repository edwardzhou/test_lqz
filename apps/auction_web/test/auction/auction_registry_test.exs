defmodule AuctionWeb.Auction.AuctionRegistryTest do
  use ExUnit.Case, async: true

  alias AuctionWeb.Auction.AuctionRegistry

  setup context do
    {:ok, registry} = AuctionRegistry.start_link(context.test)
    {:ok, registry: registry}
  end

  test "lookup non-exist auction", %{registry: registry} do
    {:error, _} = AuctionRegistry.lookup(registry, 1)
  end

  test "lookup auction", %{registry: registry} do
    {:ok, auction} = AuctionRegistry.create(registry, 1)
    {:ok, ^auction} = AuctionRegistry.lookup(registry, 1)
  end

  test "create auction_session", %{registry: registry} do
    {:ok, auction} = AuctionRegistry.create(registry, 1)
    assert auction != nil
  end

  test "create auction_session returns existing", %{registry: registry} do
    {:ok, auction} = AuctionRegistry.create(registry, 1)
    {:ok, ^auction} = AuctionRegistry.create(registry, 1)
  end

  test "shutdown auction_session", %{registry: registry} do
    {:ok, auction} = AuctionRegistry.create(registry, 1)
    # GenServer.stop(auction)
    Process.exit(auction, :shutdown)
    ref = Process.monitor(auction)
    assert_receive {:DOWN, ^ref, _, _, _}
    {:error, nil} = AuctionRegistry.lookup(registry, 1)
  end
end
