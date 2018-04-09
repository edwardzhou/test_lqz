defmodule AuctionWeb.AuctionView do
  use AuctionWeb, :view
  alias Timex.Timezone

  def simple_datetime(time) do
    local_time = Timezone.convert(time, "Asia/Shanghai")
    {:ok, dt} = Timex.format(local_time, "{M}月{D}日 {h24}:{m}")
    dt
  end

end
