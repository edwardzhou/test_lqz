defmodule DB.Uploaders.Image do
  use DB.Uploaders.ImageBase

  # Define a thumbnail transformation:
  def transform(:original, _) do
    {:convert, "-strip -thumbnail 800x400^ -gravity center -extent 800x400"}
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 400x200^ -gravity center -extent 400x200"}
  end

end
