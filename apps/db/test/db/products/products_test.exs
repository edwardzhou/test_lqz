defmodule DB.ProductsTest do
  use DB.DataCase

  alias DB.Product

  describe "products" do
    
    @valid_attrs %{name: "some name", grade: "some grade", price: 111.11, specification: "some specification",
                   description: "some description"}
    @update_attrs %{name: "some updated name", price: 222}
    @invalid_attrs %{name: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Product.create_product()

      product
    end
    
    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Product.create_product(@valid_attrs)
      assert product.name == "some name"
      assert product.grade == "some grade"
      assert product.price == 111.11
      assert product.specification == "some specification"
      assert product.description == "some description"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Product.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, product} = Product.update_product(product, @update_attrs)
      assert %Product{} = product
      assert product.name == "some updated name"
      assert product.price == 222
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Product.update_product(product, @invalid_attrs)
      assert product == Product.get_product!(product.id)
    end
  end
end
