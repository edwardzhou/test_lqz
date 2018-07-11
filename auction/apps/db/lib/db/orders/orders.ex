defmodule DB.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias DB.Repo

  alias DB.Orders.Order
  alias DB.Accounts

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  def create_order_from_auction(%{top_bid: %{bidder: bidder}} = auction_state) 
    when is_nil(bidder) do
    nil
  end

  def create_order_from_auction(%{} = auction_state) do
    %{bidder: bidder, bid: bid} = auction_state.top_bid
    user = Accounts.find_user_by_nickname(bidder)
    order_attrs = %{
      amount: bid,
      user_id: user.id,
      state: "initial",
      auction_item_id: auction_state.auction_item_id,
      auction_id: auction_state.auction_id,
      commission_rate: auction_state.commission_rate,
      commission_amount: auction_state.commissions

    }
    create_order(order_attrs)
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{source: %Order{}}

  """
  def change_order(%Order{} = order) do
    Order.changeset(order, %{})
  end
end
