defmodule Db.OrdersTest do
  use Db.DataCase

  alias Db.Orders

  describe "orders" do
    alias Db.Orders.Order

    @valid_attrs %{amount: "120.5", auction_id: 42, auction_item_id: 42, cancelled_at: "2010-04-17 14:00:00.000000Z", commission_amount: "120.5", commission_rate: "120.5", completed_at: "2010-04-17 14:00:00.000000Z", memo: "some memo", paid_at: "2010-04-17 14:00:00.000000Z", payment_id: 42, returned_at: "2010-04-17 14:00:00.000000Z", shipped_at: "2010-04-17 14:00:00.000000Z", state: "some state", user_id: 42}
    @update_attrs %{amount: "456.7", auction_id: 43, auction_item_id: 43, cancelled_at: "2011-05-18 15:01:01.000000Z", commission_amount: "456.7", commission_rate: "456.7", completed_at: "2011-05-18 15:01:01.000000Z", memo: "some updated memo", paid_at: "2011-05-18 15:01:01.000000Z", payment_id: 43, returned_at: "2011-05-18 15:01:01.000000Z", shipped_at: "2011-05-18 15:01:01.000000Z", state: "some updated state", user_id: 43}
    @invalid_attrs %{amount: nil, auction_id: nil, auction_item_id: nil, cancelled_at: nil, commission_amount: nil, commission_rate: nil, completed_at: nil, memo: nil, paid_at: nil, payment_id: nil, returned_at: nil, shipped_at: nil, state: nil, user_id: nil}

    def order_fixture(attrs \\ %{}) do
      {:ok, order} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Orders.create_order()

      order
    end

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = Orders.create_order(@valid_attrs)
      assert order.amount == Decimal.new("120.5")
      assert order.auction_id == 42
      assert order.auction_item_id == 42
      assert order.cancelled_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert order.commission_amount == Decimal.new("120.5")
      assert order.commission_rate == Decimal.new("120.5")
      assert order.completed_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert order.memo == "some memo"
      assert order.paid_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert order.payment_id == 42
      assert order.returned_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert order.shipped_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert order.state == "some state"
      assert order.user_id == 42
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      assert {:ok, order} = Orders.update_order(order, @update_attrs)
      assert %Order{} = order
      assert order.amount == Decimal.new("456.7")
      assert order.auction_id == 43
      assert order.auction_item_id == 43
      assert order.cancelled_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert order.commission_amount == Decimal.new("456.7")
      assert order.commission_rate == Decimal.new("456.7")
      assert order.completed_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert order.memo == "some updated memo"
      assert order.paid_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert order.payment_id == 43
      assert order.returned_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert order.shipped_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert order.state == "some updated state"
      assert order.user_id == 43
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end
end
