defmodule AuctionWeb.AuctionController do
  use AuctionWeb, :controller

  alias DB.Auctions
  alias DB.Auctions.Auction
  alias AuctionWeb.Auction.AuctionRegistry

  def index(conn, _params) do
    AuctionRegistry.start_link(:registry)
    AuctionRegistry.create(:registry, 1)

    auctions = 
      Auctions.list_auctions() 
      |> Auctions.load_items()
      
    conn
    |> put_layout("app.html")
    |> render("index.html", auctions: auctions)
  end

  def new(conn, _params) do
    changeset = Auctions.change_auction(%Auction{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id, "name" => user_id}) do
    conn
    |> put_layout("auction.html")
    |> assign(:auction_id, id)
    |> assign(:user_id, user_id)
    |> render("show.html", auction: nil)
  end

  def show(conn, %{"id" => id}) do
    # auction = Auctions.get_auction!(id)
    current_user = get_session(conn, :current_user)
    if current_user == nil do
      conn
      |> redirect(to: "/auth/wechat")
      |> halt
    end

    conn
    |> put_layout("auction.html")
    |> assign(:auction_id, id)
    |> assign(:user_id, current_user.name)
    |> render("show.html", auction: nil)
  end

end
