defmodule AuctionWeb.Router do
  use AuctionWeb, :router

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

  scope "/", AuctionWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/auctions", AuctionController

    resources "/users", UserController
  end

  scope "/auth", AuctionWeb do
    pipe_through :browser

    get "/logout", AuthenticationController, :delete
    get "/:provider", AuthenticationController, :request
    get "/:provider/callback", AuthenticationController, :callback
    post "/:provider/callback", AuthenticationController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", AuctionWeb do
  #   pipe_through :api
  # end
end
