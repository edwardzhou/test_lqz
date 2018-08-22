use Mix.Config

# Configure your database
config :db, DB.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: System.get_env("AUCTION_DB_HOST") || "localhost",
  username: System.get_env("AUCTION_DB_USER") || "postgres",
  password: System.get_env("AUCTION_DB_PASSWORD") || "postgres",
  database: System.get_env("AUCTION_DB_NAME") || "auction_dev",
  port: System.get_env("AUCTION_DB_PORT") || 5432,
  pool_size: 10
