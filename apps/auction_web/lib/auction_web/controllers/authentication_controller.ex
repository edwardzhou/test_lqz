defmodule AuctionWeb.AuthenticationController do
  use AuctionWeb, :controller
  plug Ueberauth

  alias Auction.Accounts
  alias Auction.Accounts.Authentication
  alias Ueberauth.Strategy.Helpers

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user = %{id: auth.uid, name: auth.info.name || auth.info.nickname, avatar: auth.info.image}
    IO.puts "auth: #{inspect(auth)}"
    IO.puts "User: #{inspect(user)}"
    conn
    |> put_flash(:info, "Successfully authenticated.")
    |> put_session(:current_user, user)
    |> redirect(to: "/")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out.")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end
end
