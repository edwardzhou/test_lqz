defmodule AuctionWeb.LayoutView do
  use AuctionWeb, :view

  def page_title(assigns) do
    assigns[:page_title] || "拍品信息"
  end
end
