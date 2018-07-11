use Mix.Config

config :db, ecto_repos: [DB.Repo]

config :arc,
       storage: Arc.Storage.Local

import_config "#{Mix.env}.exs"
