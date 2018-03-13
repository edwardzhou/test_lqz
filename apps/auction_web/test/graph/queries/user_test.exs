defmodule DcGraph.Schema.UserTest do
  use AuctionWeb.GraphCase
  alias DB.Repo
  alias DB.Accounts

  def test_user_attributes, do: %{
    username: "test1",
    nickname: "Unit tester",
    telephone: "18620310001",
    email: "test1@test.com",
    encrypted_password: "password"
  }

  describe "fetching user" do
    setup do
      {:ok, user} = Accounts.create_user(test_user_attributes())
      {:ok, %{user: user}}
    end

    @tag query: """
    query webQueryUser($id: ID!) {
      accountsUsers(id: $id) {
        username
        nickname
        telephone
        email
      }
    }
    """
    test "returns a user", %{user: user} = tags do
      q = %{
        query: tags.query,
        variables: %{"id" => user.id}
      }

      user = execute_document(q)[:data]["accountsUsers"]

      assert user["username"] == "test1"
      assert user["nickname"] == "Unit tester"
      assert user["telephone"] == "18620310001"
      assert user["email"] == "test1@test.com"
    end

    @tag query: """
    query webQueryUser($id: ID!) {
      accountsUsers(id: $id) {
        username
        nickname
        telephone
        email
      }
    }
    """
    test "returns nil for non exist id", %{user: user} = tags do
      q = %{
        query: tags.query,
        variables: %{"id" => 1}
      }

      user = execute_document(q)[:data]["accountsUsers"]

      assert user == nil
    end
  end
end
