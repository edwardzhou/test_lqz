defmodule AuctionWeb.PageController do
  use AuctionWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", current_user: get_session(conn, :current_user)
  end
end
