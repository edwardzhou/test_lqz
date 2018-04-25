defmodule AuctionWeb.AuctionView do
  use AuctionWeb, :view
  alias Timex.Timezone
  alias DB.Uploaders.Image

  def simple_datetime(time) do
    Timex.local(time) |> Timex.format!("%Y-%m-%d %H:%M", :strftime)
  end

  def img_url(logo) do
    Image.url(logo)
  end
end
