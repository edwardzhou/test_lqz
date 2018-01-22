defmodule AuctionWeb.AuctionChannel do
  use AuctionWeb, :channel

  def join("auction:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("auction:" <> _auction_id, payload, socket) do
    if authorized?(payload) do
      send(self(), {:after_join, payload["user_id"]})
      :timer.send_after(1000, {:countdown, 29})
      # send(self(), {:after_join, payload.user_id})
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info({:after_join, user_id}, socket) do
    broadcast! socket, "bidder_join", %{user_id: user_id}
    {:noreply, socket}
  end


  def handle_info({:countdown, 0}, socket) do
    broadcast! socket, "bid_endded", %{}
    {:noreply, socket}
  end
  def handle_info({:countdown, counter}, socket) do
    broadcast! socket, "countdown", %{counter: counter}
    :timer.send_after(1000, {:countdown, counter - 1})
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
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
