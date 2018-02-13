defmodule Auction.Auctions.Auction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Auction.Auctions.Auction


  schema "auctions" do
    field :name, :string
    field :logo, :string
    field :starts_at, :utc_datetime, comment: "开始时间"
    field :ends_at, :utc_datetime, comment: "结束时间"

    timestamps()
  end

  @doc false
  def changeset(%Auction{} = auction, attrs) do
    auction
    |> cast(attrs, [:name, :logo, :starts_at, :ends_at])
    |> validate_required([:name, :logo, :starts_at, :ends_at])
  end
end
