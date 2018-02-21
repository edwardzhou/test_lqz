defmodule Auction.Auctions.Auction do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "auctions" do
    field :name, :string
    field :logo, Auction.Uploaders.Image.Type
    field :starts_at, Ecto.DateTime, comment: "开始时间"
    field :ends_at, Ecto.DateTime, comment: "结束时间"

    timestamps()
  end

  @doc false
  def changeset(%Auction.Auctions.Auction{} = auction, attrs) do
    auction
    |> cast(attrs, [:name, :starts_at, :ends_at])
    |> cast_attachments(attrs, [:logo])
    |> validate_required([:name, :logo, :starts_at, :ends_at])
  end
end
