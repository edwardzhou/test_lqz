use Mix.Config

# Configure your database
config :auction, Auction.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "auction_dev",
  hostname: "localhost",
  pool_size: 10
