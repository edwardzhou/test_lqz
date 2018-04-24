defmodule DB.Products do
  import Ecto.Query, warn: false
  alias DB.Repo
  alias DB.Product

  def get_product!(id), do: Repo.get!(Product, id)

  def list_products do
    Repo.all(Product)
  end
end
