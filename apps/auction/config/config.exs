use Mix.Config

config :auction, ecto_repos: [Auction.Repo]

config :arc,
       storage: Arc.Storage.Local

import_config "#{Mix.env}.exs"
