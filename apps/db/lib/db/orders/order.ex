defmodule DB.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias DB.Orders.Order
  alias DB.Auctions.Auction
  alias DB.Auctions.AuctionItem
  alias DB.Accounts.User 


  schema "orders" do
    field :amount, :decimal
    # field :auction_id, :integer
    # field :auction_item_id, :integer
    field :cancelled_at, :utc_datetime
    field :commission_amount, :decimal
    field :commission_rate, :decimal
    field :completed_at, :utc_datetime
    field :memo, :string
    field :paid_at, :utc_datetime
    field :payment_id, :integer
    field :returned_at, :utc_datetime
    field :shipped_at, :utc_datetime
    field :state, :string
    # field :user_id, :integer

    belongs_to :auction, Auction
    belongs_to :auction_item, AuctionItem
    belongs_to :user, User
    

    timestamps()
  end

  @doc false
  def changeset(%Order{} = order, attrs) do
    order
    |> cast(attrs, [:user_id, :auction_item_id, :auction_id, :amount, :commission_rate, :commission_amount, :state, :memo, :paid_at, :payment_id, :shipped_at, :completed_at, :cancelled_at, :returned_at])
    |> validate_required([:user_id, :auction_item_id, :auction_id, :amount, :commission_rate, :commission_amount, :state])
  end
end
