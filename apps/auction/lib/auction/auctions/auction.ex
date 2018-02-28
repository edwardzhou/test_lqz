defmodule Auction.Auctions.Auction do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "auctions" do
    field :name, :string
    field :logo, Auction.Uploaders.Image.Type
    field :starts_at, :utc_datetime, comment: "开始时间"
    field :ends_at, :utc_datetime, comment: "结束时间"
    timestamps()
  end

  @doc false
  def changeset(%Auction.Auctions.Auction{} = auction, attrs \\ %{}) do
    data_time_attrs = data_time_attrs(attrs)
    auction
    |> cast(data_time_attrs, [:name, :starts_at, :ends_at])
    |> cast_attachments(data_time_attrs, [:logo])
    |> validate_required([:name, :logo, :starts_at, :ends_at])
  end

  def data_time_attrs(%{ends_at: ends_at, starts_at: starts_at} = attrs) do
    attrs
    |> put_in([:ends_at, :minute], ends_at.min)
    |> put_in([:starts_at, :minute], starts_at.min)
  end

  def data_time_attrs(attrs) do attrs end
end
