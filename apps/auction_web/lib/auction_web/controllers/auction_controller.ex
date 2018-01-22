defmodule AuctionWeb.AuctionController do
  use AuctionWeb, :controller

  alias Auction.Auctions
  alias Auction.Auctions.Auction

  def index(conn, _params) do
    auctions = Auctions.list_auctions()
    render(conn, "index.html", auctions: auctions)
  end

  def new(conn, _params) do
    changeset = Auctions.change_auction(%Auction{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"auction" => auction_params}) do
    case Auctions.create_auction(auction_params) do
      {:ok, auction} ->
        conn
        |> put_flash(:info, "Auction created successfully.")
        |> redirect(to: auction_path(conn, :show, auction))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    # auction = Auctions.get_auction!(id)
    assign(conn, :auction_id, id)
    |> assign(:user_id, "abc")
    |> render("show.html", auction: nil)
  end

  def edit(conn, %{"id" => id}) do
    auction = Auctions.get_auction!(id)
    changeset = Auctions.change_auction(auction)
    render(conn, "edit.html", auction: auction, changeset: changeset)
  end

  def update(conn, %{"id" => id, "auction" => auction_params}) do
    auction = Auctions.get_auction!(id)

    case Auctions.update_auction(auction, auction_params) do
      {:ok, auction} ->
        conn
        |> put_flash(:info, "Auction updated successfully.")
        |> redirect(to: auction_path(conn, :show, auction))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", auction: auction, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    auction = Auctions.get_auction!(id)
    {:ok, _auction} = Auctions.delete_auction(auction)

    conn
    |> put_flash(:info, "Auction deleted successfully.")
    |> redirect(to: auction_path(conn, :index))
  end
end
