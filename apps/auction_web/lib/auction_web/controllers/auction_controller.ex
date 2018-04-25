defmodule AuctionWeb.AuctionController do
  use AuctionWeb, :controller

  alias DB.Accounts
  alias DB.Auctions
  alias DB.Auctions.Auction
  alias AuctionWeb.Auction.AuctionRegistry

  def index(conn, _params) do
#    AuctionRegistry.start_link(:registry)
#    AuctionRegistry.create(:registry, 1)
    auctions = Auctions.auctionable_auctions() |> Auctions.load_items()
    conn
    |> render("index.html", auctions: auctions)
  end

  def new(conn, _params) do
    changeset = Auctions.change_auction(%Auction{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id, "name" => nickname}) do
    user = Accounts.find_or_initialize_user_by_nickname(nickname)
    
    conn
    |> put_session(:current_user, user)
    |> show(%{"id" => id})
  end

  def show(conn, %{"id" => id}) do
    current_user = get_session(conn, :current_user)
    if current_user == nil do
      conn
      |> redirect(to: "/auth/wechat")
      |> halt
    end

    conn
    |> put_layout("auction.html")
    |> assign(:auction_id, id)
    |> assign(:user_id, current_user.nickname)
    |> render("show.html", auction: nil)
  end

end
