# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :auction_admin,
  namespace: AuctionAdmin,
  ecto_repos: [DB.Repo]

# Configures the endpoint
config :auction_admin, AuctionAdmin.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DE6KbPGum3gfPPqGB499JKmZ1IUkL7W6E3jNXhxWI3PLuti3MZTwwoMy9sKIbTyi",
  render_errors: [view: AuctionAdmin.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AuctionAdmin.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :auction_admin, :generators,
  context_app: false

config :ex_admin,
  repo: DB.Repo,
  module: AuctionAdmin,
  modules: [
    AuctionAdmin.ExAdmin.Dashboard,
    AuctionAdmin.ExAdmin.Authentication,
    AuctionAdmin.ExAdmin.Auction,
    AuctionAdmin.ExAdmin.Product
  ],
  head_template: {AuctionAdmin.AdminView, "admin_layout.html"}


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :xain, :after_callback, {Phoenix.HTML, :raw}

