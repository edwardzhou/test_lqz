defmodule AuctionAdmin.ExAdmin.Product do
  use ExAdmin.Register
  alias Auction.Product

  register_resource Product do

    index do
      column :id
      column :name
      column :grade
      column :price
      column :specification
      actions()
    end

#    show auction do
#      attributes_table do
#        row :id
#        row :logo, fn(auction) -> img src: Image.url(auction.logo) end
#        row :starts_at
#        row :ends_at
#        row :created_at
#        row :updated_at
#      end
#    end

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

