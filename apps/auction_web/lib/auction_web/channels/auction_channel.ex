defmodule AuctionWeb.AuctionChannel do
  use AuctionWeb, :channel
  alias AuctionWeb.Auction.AuctionServer

  def join("auction:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("auction:" <> _auction_id, payload, socket) do
    if authorized?(payload) do
      send(self(), {:after_join, socket.assigns.user_id})
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info({:after_join, user_id}, socket) do
    AuctionServer.bidder_join(socket.assigns.user_id)

    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("new_bid", payload, socket) do
    # broadcast! socket, "on_new_bid", %{new_bid: payload["increase"]}
    # :timer.send_after(1000, {:countdown, 29})
    AuctionServer.new_bid(socket.assigns.user_id, payload["increase"])
    {:reply, {:ok, %{}}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (auction:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
