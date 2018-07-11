defmodule Accounts.AuthenticatorTest do
  use DB.DataCase
  alias DB.Accounts
  alias DB.Accounts.Authentication
  alias DB.Accounts.Authenticator
  alias DB.Accounts.User

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
    union_id: nil
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
    union_id: "the_union_id"
  }

  describe "authenticator" do
    def fixture(:authentication) do
      {:ok, authentication} = Accounts.create_authentication(@existing_auth_attrs)
      {:ok, _user} = Accounts.user_from_auth(authentication, nil)
      authentication
    end

    test "authenticate/1 returns ok" do
      assert {:ok, _} = Authenticator.authenticate(@auth_attrs)
    end

    test "authenticate/1 create new authentication" do
      assert {:ok, %User{} = user} = Authenticator.authenticate(@auth_attrs)
      assert user.nickname == "tester"
      assert user.email == "test@test.com"
      # assert user.image == "some image"
    end

    test "authenticate/1 returns existing authentication" do
      fixture(:authentication)

      assert {:ok, %User{nickname: "existing_tester"} = user} =
               Authenticator.authenticate(@existing_auth_attrs)
    end

    test "authenticate/1 create new auth with existing user by the same union_id" do
      fixture(:authentication)
      union_id_attrs = %{@auth_attrs | union_id: "the_union_id"}
      user = Authenticator.authenticate(union_id_attrs)

      assert {:ok, %User{nickname: "existing_tester"}} = user
    end
  end
end
