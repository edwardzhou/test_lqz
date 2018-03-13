defmodule AuctionAdmin.ExAdmin.Product do
  use ExAdmin.Register
  alias DB.Product

  register_resource Product do

    index do
      column :id
      column :name
      column :grade
      column :price
      column :specification
      actions()
    end

    form product do
      inputs do
        input product, :name
        input product, :grade
        input product, :price
        input product, :specification
        input product, :description, type: :text, class: "auction-editor"
      end
      javascript do
        """
        $(document).ready(function() {
          var editor = new Simditor({
            textarea: $('#product_description')
          });
        });
        """
      end
    end
  end
end

