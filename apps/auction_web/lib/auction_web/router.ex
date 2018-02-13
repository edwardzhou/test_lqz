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

    get "/logout", AuthenticationController, :delete, as: :auth
    get "/:provider", AuthenticationController, :request, as: :auth
    get "/:provider/callback", AuthenticationController, :callback, as: :auth
    post "/:provider/callback", AuthenticationController, :callback, as: :auth
  end

  # Other scopes may use custom stacks.
  # scope "/api", AuctionWeb do
  #   pipe_through :api
  # end
end
