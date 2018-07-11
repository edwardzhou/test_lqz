defmodule AuctionAdmin.PageController do
  use AuctionAdmin, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
