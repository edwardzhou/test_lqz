defmodule AuctionAdmin.ExAdmin.Product do
  use ExAdmin.Register
  alias DB.Product

  import AuctionAdmin.Gettext

  register_resource Product do
    menu label: gettext("Products")

    index do
      column :id
      column :name, label: gettext("Product Name")
      column :grade, label: gettext("Grade")
      column :price, label: gettext("Price")
      column :specification, label: gettext("Specification")
      actions()
    end

    form product do
      inputs do
        input product, :name, label: gettext("Product Name")
        input product, :grade, label: gettext("Grade")
        input product, :price, label: gettext("Price")
        input product, :specification, label: gettext("Specification")
        input product, :description, type: :text, class: "auction-editor", label: gettext("Specification")
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

