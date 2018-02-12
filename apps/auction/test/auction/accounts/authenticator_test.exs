defmodule Accounts.AuthenticatorTest do
  use Auction.DataCase
  alias Auction.Accounts
  alias Auction.Accounts.Authentication
  alias Auction.Accounts.Authenticator
  alias Auction.Accounts.User

  @auth_attrs %{ 
    provider: "wechat", 
    uid: "10001", 
    email: "test@test.com", 
    image: "some image", 
    name: "tester", 
    nickname: "tester", 
    refresh_token: "some refresh_token", 
    token: "some token", 
    token_secret: "some token_secret", 
    union_id: "some union_id"
  }

  @existing_auth_attrs %{ 
    provider: "wechat", 
    uid: "10002", 
    email: "test2@test.com", 
    image: "some image", 
    name: "tester", 
    nickname: "existing_tester", 
    refresh_token: "some refresh_token", 
    token: "some token", 
    token_secret: "some token_secret", 
    union_id: "some union_id"
  }

  describe "authenticator" do
    def fixture(:authentication) do
      {:ok, authentication} = Accounts.create_authentication(@existing_auth_attrs)
      {:ok, _user} = Accounts.new_user_from_auth(authentication)
      authentication
    end

    test "authenticate/1 returns ok" do
      assert {:ok, _} = Authenticator.authenticate(@auth_attrs)
    end

    test "authenticate/1 create new authentication" do
      assert {:ok, %User{} = user} = Authenticator.authenticate(@auth_attrs)
      IO.puts "user => #{inspect(user)}"
      assert user.nickname == "tester"
      assert user.email == "test@test.com"
      # assert user.image == "some image"
    end

    test "authenticate/1 returns existing authentication" do
      fixture(:authentication)
      
      assert {:ok, %User{nickname: "existing_tester"} = user} = Authenticator.authenticate(@existing_auth_attrs)
    end
  end
end