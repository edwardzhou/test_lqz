defmodule AuctionWeb.AuthenticationControllerTest do
  use AuctionWeb.ConnCase
  require Ueberauth
  alias Auction.Accounts

  @create_attrs %{email: "some email", image: "some image", name: "some name", nickname: "some nickname", provider: "some provider", refresh_token: "some refresh_token", token: "some token", token_secret: "some token_secret", uid: "some uid", union_id: "some union_id", user_id: 42}
  @update_attrs %{email: "some updated email", image: "some updated image", name: "some updated name", nickname: "some updated nickname", provider: "some updated provider", refresh_token: "some updated refresh_token", token: "some updated token", token_secret: "some updated token_secret", uid: "some updated uid", union_id: "some updated union_id", user_id: 43}
  @invalid_attrs %{email: nil, image: nil, name: nil, nickname: nil, provider: nil, refresh_token: nil, token: nil, token_secret: nil, uid: nil, union_id: nil, user_id: nil}

  def fixture(:authentication) do
    {:ok, authentication} = Accounts.create_authentication(@create_attrs)
    authentication
  end

  defp create_authentication(_) do
    authentication = fixture(:authentication)
    {:ok, authentication: authentication}
  end
end
