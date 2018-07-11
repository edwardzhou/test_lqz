defmodule DB.Product do
  use Ecto.Schema
  alias DB.Product
  alias DB.Repo
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :grade, :string, comment: "品相等级"
    field :price, :decimal
    field :specification, :string, comment: "拍品规格"
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [:name, :price, :specification, :grade, :description])
    |> validate_required([:name, :price, :specification, :grade, :description])
  end

  def create_product(attrs \\ %{}) do
    %Product{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def update_product(%Product{} = product, attrs) do
    product
    |> changeset(attrs)
    |> Repo.update()
  end
end
