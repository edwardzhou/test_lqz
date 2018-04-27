defmodule DB.Uploaders.AuctionItem do
  use DB.Uploaders.ImageBase

  # Define a thumbnail transformation:
  def transform(:original, _) do
    {:convert, "-strip -thumbnail 600x600^ -gravity center -extent 600x600"}
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 200x200^ -gravity center -extent 200x200"}
  end
end
