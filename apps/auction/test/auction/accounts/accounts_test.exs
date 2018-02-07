defmodule Auction.AccountsTest do
  use Auction.DataCase

  alias Auction.Accounts

  describe "users" do
    alias Auction.Accounts.User

    @valid_attrs %{email: "some email", encrypted_password: "some encrypted_password", nickname: "some nickname", telephone: "some telephone", username: "some username"}
    @update_attrs %{email: "some updated email", encrypted_password: "some updated encrypted_password", nickname: "some updated nickname", telephone: "some updated telephone", username: "some updated username"}
    @invalid_attrs %{email: nil, encrypted_password: nil, nickname: nil, telephone: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.encrypted_password == "some encrypted_password"
      assert user.nickname == "some nickname"
      assert user.telephone == "some telephone"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.encrypted_password == "some updated encrypted_password"
      assert user.nickname == "some updated nickname"
      assert user.telephone == "some updated telephone"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "authentications" do
    alias Auction.Accounts.Authentication

    @valid_attrs %{email: "some email", image: "some image", name: "some name", nickname: "some nickname", provider: "some provider", refresh_token: "some refresh_token", token: "some token", token_secret: "some token_secret", uid: "some uid", union_id: "some union_id", user_id: 42}
    @update_attrs %{email: "some updated email", image: "some updated image", name: "some updated name", nickname: "some updated nickname", provider: "some updated provider", refresh_token: "some updated refresh_token", token: "some updated token", token_secret: "some updated token_secret", uid: "some updated uid", union_id: "some updated union_id", user_id: 43}
    @invalid_attrs %{email: nil, image: nil, name: nil, nickname: nil, provider: nil, refresh_token: nil, token: nil, token_secret: nil, uid: nil, union_id: nil, user_id: nil}

    def authentication_fixture(attrs \\ %{}) do
      {:ok, authentication} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_authentication()

      authentication
    end

    test "list_authentications/0 returns all authentications" do
      authentication = authentication_fixture()
      assert Accounts.list_authentications() == [authentication]
    end

    test "get_authentication!/1 returns the authentication with given id" do
      authentication = authentication_fixture()
      assert Accounts.get_authentication!(authentication.id) == authentication
    end

    test "create_authentication/1 with valid data creates a authentication" do
      assert {:ok, %Authentication{} = authentication} = Accounts.create_authentication(@valid_attrs)
      assert authentication.email == "some email"
      assert authentication.image == "some image"
      assert authentication.name == "some name"
      assert authentication.nickname == "some nickname"
      assert authentication.provider == "some provider"
      assert authentication.refresh_token == "some refresh_token"
      assert authentication.token == "some token"
      assert authentication.token_secret == "some token_secret"
      assert authentication.uid == "some uid"
      assert authentication.union_id == "some union_id"
      assert authentication.user_id == 42
    end

    test "create_authentication/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_authentication(@invalid_attrs)
    end

    test "update_authentication/2 with valid data updates the authentication" do
      authentication = authentication_fixture()
      assert {:ok, authentication} = Accounts.update_authentication(authentication, @update_attrs)
      assert %Authentication{} = authentication
      assert authentication.email == "some updated email"
      assert authentication.image == "some updated image"
      assert authentication.name == "some updated name"
      assert authentication.nickname == "some updated nickname"
      assert authentication.provider == "some updated provider"
      assert authentication.refresh_token == "some updated refresh_token"
      assert authentication.token == "some updated token"
      assert authentication.token_secret == "some updated token_secret"
      assert authentication.uid == "some updated uid"
      assert authentication.union_id == "some updated union_id"
      assert authentication.user_id == 43
    end

    test "update_authentication/2 with invalid data returns error changeset" do
      authentication = authentication_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_authentication(authentication, @invalid_attrs)
      assert authentication == Accounts.get_authentication!(authentication.id)
    end

    test "delete_authentication/1 deletes the authentication" do
      authentication = authentication_fixture()
      assert {:ok, %Authentication{}} = Accounts.delete_authentication(authentication)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_authentication!(authentication.id) end
    end

    test "change_authentication/1 returns a authentication changeset" do
      authentication = authentication_fixture()
      assert %Ecto.Changeset{} = Accounts.change_authentication(authentication)
    end
  end
end
