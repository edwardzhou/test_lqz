defmodule AuctionWeb.Schema.UpdateRealnameTest do
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

  describe "submit realname verification" do
    setup do
      {:ok, user} = Accounts.create_user(test_user_attributes())
      {:ok, %{user: user}}
    end

    @tag query: """
      mutation testUpdateRealname($input: RealnameVerificationInput!) {
        updateRealname(input: $input) {
          realname
          idNo
          state
          user {
            id
            nickname
          }
        }
      }
    """
    test "returns user & verification info", %{user: user} = tags do
      q = %{
        query: tags.query,
        variables: %{
          "input" => %{
            "idNo" => "622725198010053405",
            "realname" => "张三",
            "userId" => user.id
          }
        }
      }

      result = execute_document(q)
      errors = result[:errors]
      assert errors == nil
      data = result[:data]["updateRealname"]
      assert String.to_integer(data["user"]["id"]) == user.id
      assert data["user"]["nickname"] == "Unit tester"
    end
  end
end