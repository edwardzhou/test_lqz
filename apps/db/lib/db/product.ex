defmodule DB.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias DB.Product


  schema "products" do
    field :description, :string
    field :grade, :string, comment: "品相等级"
    field :name, :string
    field :price, :decimal
    field :specification, :string, comment: "拍品规格"

    timestamps()
  end

  @doc false
  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [:name, :price, :specification, :grade, :description])
    |> validate_required([:name, :price, :specification, :grade, :description])
  end
end
