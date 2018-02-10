defmodule AuctionAdmin.Router do
  use AuctionAdmin, :router
  use ExAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExAdmin do
    pipe_through :browser # Use the default browser stack

    # get "/", PageController, :index
    admin_routes()
  end

  scope "/admin", ExAdmin do
    pipe_through :browser

    admin_routes()
  end

  # Other scopes may use custom stacks.
  # scope "/api", AuctionAdmin do
  #   pipe_through :api
  # end
end
