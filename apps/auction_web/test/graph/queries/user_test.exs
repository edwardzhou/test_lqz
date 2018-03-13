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
    test "returns a user", %{user: user}=tags do
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
    test "returns nil for non exist id", %{user: user}=tags do
      q = %{
        query: tags.query,
        variables: %{"id" => 1}
      }

      user = execute_document(q)[:data]["accountsUsers"]

      assert user == nil
    end
  end

  # describe "fetching a fulfillment center by IP address" do
  #   setup [:with_fc]

  #   @tag query: """
  #   query GetFulfillmentCenterByIpAddress($ipAddress: String!) {
  #     fc: getFulfillmentCenterByIpAddress(ipAddress: $ipAddress) {
  #       id
  #       slug
  #       name
  #     }
  #   }
  #   """

  #   @tag variables: %{"ipAddress" => "127.0.0.1"}
  #   test "it returns the fulfillment center that matches the IP address", tags do
  #     data = execute_document(tags)[:data]

  #     assert data["fc"]["id"] == id(tags[:fc])
  #     assert data["fc"]["slug"] == "stockton"
  #     assert data["fc"]["name"] == "Stockton, CA"
  #   end

  #   @tag variables: %{"ipAddress" => "192.168.0.1"}
  #   test "it returns null when an FC cannot be found by the given IP address", tags do
  #     data = execute_document(tags)[:data]

  #     assert data["fc"] == nil
  #   end
  # end

  # @tag query: """
  # query GetNode($id: ID!) {
  #   node(id: $id) {
  #     ... on FulfillmentCenter {
  #       id
  #       slug
  #       name
  #     }
  #   }
  # }
  # """
  # describe "fetching a fulfillment center via node" do
  #   setup [:with_fc, :with_fc_id]

  #   test "it returns the fulfillment center that matches the ID", tags do
  #     data = execute_document(tags)[:data]

  #     assert data["node"]["id"] == id(tags[:fc])
  #     assert data["node"]["slug"] == "stockton"
  #     assert data["node"]["name"] == "Stockton, CA"
  #   end

  #   @tag variables: %{"id" => to_global_id("FulfillmentCenter", "0")}
  #   test "it returns null when an FC cannot be found from the given ID", tags do
  #     data = execute_document(tags)[:data]

  #     assert data["node"] == nil
  #   end
  # end

  # defp with_fc(_tags) do
  #   {:ok, fc: create()}
  # end

  # defp with_fc_id(%{fc: fc}) do
  #   {:ok, variables: %{"id" => id(fc)}}
  # end

  # defp id(fc), do: to_global_id("FulfillmentCenter", fc.id)
end
