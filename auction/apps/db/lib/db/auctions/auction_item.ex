defmodule DB.Auctions.AuctionItem do
  use Ecto.Schema
  import Ecto.Changeset
  alias DB.Product
  alias DB.Auctions.{AuctionItem, Auction}
  alias DB.EctoEnums.AuctionItemStateEnum

  schema "auction_items" do
    field :current_price, :decimal, comment: "当前报价"
    field :commission_rate, :decimal, comment: "佣金比例 %"
    field :commission_amount, :decimal, comment: "佣金金额"
    field :margin, :decimal, comment: "利润"
    field :start_price, :decimal, comment: "起拍价格"
    field :starts_at, :utc_datetime, comment: "起拍时间"
    field :ends_at, :utc_datetime, comment: "结束时间"
    field :seq_no, :integer, comment: "拍品顺序"
    field :state, AuctionItemStateEnum, comment: "状态"
    field :item_logo, DB.Uploaders.AuctionItem.Type, comment: "图标"
    field :description, :string, comment: "描述"
    field :title, :string, comment: "拍品名称"
    field :specification, :string, comment: "规格说明"
    field :grade, :string, comment: "拍品等级" 

    belongs_to :auction, Auction
    belongs_to :product, Product

    timestamps()
  end

  @doc false
  def changeset(%AuctionItem{} = auction_item, attrs) do
    processed_attrs = attrs |> uniq_filename_attrs

    auction_item
    |> cast(processed_attrs, [:start_price, :starts_at, :ends_at, :current_price, :margin,
      :commission_rate, :commission_amount, :state, :item_logo, :title,
      :description, :specification, :grade, :auction_id, :product_id])
    |> validate_required([:start_price, :starts_at, :current_price, :margin,
      :commission_rate, :commission_amount, :title, :description])
  end

  def uniq_filename_attrs(%{item_logo: item_logo} = attrs)
      when is_map(item_logo) do
    name =
      :md5
      |> :crypto.hash(item_logo.path)
      |> Base.encode16()

    item_logo = %Plug.Upload{item_logo | filename: "#{name}#{Path.extname(item_logo.filename)}"}
    %{attrs | item_logo: item_logo}
  end

  def uniq_filename_attrs(attrs) do
    attrs
  end

  def states do
    AuctionItemStateEnum.__enum_map__()
  end

  @states_trans [draft: "草稿", ready: "就绪", ongoing: "拍卖中", abandoned: "流拍", completed: "完成"]
  def states_with_trans do
    Enum.map(states, fn {key, _} -> {key, @states_trans[key]} end)
  end

  def trans_state(state) do
    @states_trans[state]
  end
end
