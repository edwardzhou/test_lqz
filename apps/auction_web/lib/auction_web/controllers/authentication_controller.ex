defmodule AuctionWeb.AuthenticationController do
  use AuctionWeb, :controller
  plug(Ueberauth)

  # alias Auction.Accounts
  # alias Auction.Accounts.Authentication
  # alias Ueberauth.Strategy.Helpers
  alias DB.Accounts.Authenticator
  require Logger

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    IO.puts("ueberauth_failure: #{inspect(fails)}")

    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user = %{id: auth.uid, name: auth.info.name || auth.info.nickname, avatar: auth.info.image}
    authentication = Authenticator.authenticate(auth_params(auth))

    conn
    |> put_flash(:info, "Successfully authenticated.")
    |> put_session(:current_user, user)
    |> redirect(to: "/auctions/1")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out.")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def auth_params(%{provider: :wechat} = auth) do
    %{
      uid: auth.uid,
      name: auth.info.name || auth.info.nickname,
      nickname: auth.info.nickname,
      image: auth.info.image,
      provider: to_string(auth.provider),
      strategy: to_string(auth.strategy),
      union_id: auth.extra.raw_info.user["unionid"],
      token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token
    }
  end
end
