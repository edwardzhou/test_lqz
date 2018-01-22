use Mix.Config

config :auction, ecto_repos: [Auction.Repo]

import_config "#{Mix.env}.exs"
