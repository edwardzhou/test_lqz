defmodule AuctionWeb.AuctionItemController do
  use AuctionWeb, :controller
  alias DB.Auctions

  plug :put_layout, "go_back.html"

  def show(conn, %{"id" => id}) do
    item = Auctions.get_item!(id)
    conn
    |> render("show.html", item: item)
  end
end
