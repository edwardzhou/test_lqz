defmodule Auction.AuctionsTest do
  use Auction.DataCase

  alias Auction.Auctions

  describe "auctions" do
    alias Auction.Auctions.Auction

    @valid_attrs %{product_name: "some product_name"}
    @update_attrs %{product_name: "some updated product_name"}
    @invalid_attrs %{product_name: nil}

    def auction_fixture(attrs \\ %{}) do
      {:ok, auction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auctions.create_auction()

      auction
    end

    test "list_auctions/0 returns all auctions" do
      auction = auction_fixture()
      assert Auctions.list_auctions() == [auction]
    end

    test "get_auction!/1 returns the auction with given id" do
      auction = auction_fixture()
      assert Auctions.get_auction!(auction.id) == auction
    end

    test "create_auction/1 with valid data creates a auction" do
      assert {:ok, %Auction{} = auction} = Auctions.create_auction(@valid_attrs)
      assert auction.product_name == "some product_name"
    end

    test "create_auction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auctions.create_auction(@invalid_attrs)
    end

    test "update_auction/2 with valid data updates the auction" do
      auction = auction_fixture()
      assert {:ok, auction} = Auctions.update_auction(auction, @update_attrs)
      assert %Auction{} = auction
      assert auction.product_name == "some updated product_name"
    end

    test "update_auction/2 with invalid data returns error changeset" do
      auction = auction_fixture()
      assert {:error, %Ecto.Changeset{}} = Auctions.update_auction(auction, @invalid_attrs)
      assert auction == Auctions.get_auction!(auction.id)
    end

    test "delete_auction/1 deletes the auction" do
      auction = auction_fixture()
      assert {:ok, %Auction{}} = Auctions.delete_auction(auction)
      assert_raise Ecto.NoResultsError, fn -> Auctions.get_auction!(auction.id) end
    end

    test "change_auction/1 returns a auction changeset" do
      auction = auction_fixture()
      assert %Ecto.Changeset{} = Auctions.change_auction(auction)
    end
  end
end
