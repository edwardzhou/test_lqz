# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :auction_web,
  namespace: AuctionWeb,
  ecto_repos: [DB.Repo]

# Configures the endpoint
config :auction_web, AuctionWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MzZ/QNKVDIYYGqsPllYdyclz6iBPMYOhhDC9auuf5iBvfJ7TJ3KCmSl/GgBkPT5F",
  render_errors: [view: AuctionWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AuctionWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# config :logger, 
#   format: "$message\n", 
#   backends: [{LoggerFileBackend, :log_file}, :console]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# config :logger, :log_file,
#   format: "$time $metadata[$level] $message\n",
#   level: :debug,
#   metadata: [:request_id],
#   path: "log/auction.log"
  
config :auction_web, :generators,
  context_app: :auction

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, []},
    wechat: {Ueberauth.Strategy.Wechat, []}
  ]

config :snowflake,
  machine_id: 1,   # values are 0 thru 1023 nodes
  epoch: 1_514_736_000_000  # don't change after you decide what your epoch is

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
