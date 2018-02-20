defmodule AuctionWeb.AuctionChannel do
  use AuctionWeb, :channel
  alias AuctionWeb.Auction.AuctionServer
  # alias AuctionWeb.Auction.AuctionState

  def join("auction:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("auction:" <> _auction_id, %{"user_id" => user_id} = payload, socket) do
    if authorized?(payload) do
      socket = assign(socket, :user_id, user_id)
      send(self(), {:after_join, socket.assigns.user_id})
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end
  def join("auction:" <> _auction_id, %{} = payload, socket) do
    if authorized?(payload) do
      send(self(), {:after_join, socket.assigns.user_id})
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info({:after_join, _user_id}, socket) do
    AuctionServer.bidder_join(socket.assigns.user_id)

    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    # AuctionServer.bidder_join(socket.assigns.user_id)
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("new_bid", payload, socket) do
    # broadcast! socket, "on_new_bid", %{new_bid: payload["increase"]}
    # :timer.send_after(1000, {:countdown, 29})
    AuctionServer.new_bid(socket.assigns.user_id, payload["increase"])

    # state = %AuctionState{ top_bid: %{bidder: socket.assigns.user_id, bid: payload["increase"] } }
    # broadcast socket, "on_new_bid", state

    {:reply, {:ok, %{}}, socket}
  end

  def handle_in("restart", _payload, socket) do
    # broadcast! socket, "on_new_bid", %{new_bid: payload["increase"]}
    # :timer.send_after(1000, {:countdown, 29})
    AuctionServer.restart()
    {:reply, {:ok, %{}}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (auction:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
