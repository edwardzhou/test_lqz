defmodule Auction.Application do
  @moduledoc """
  The Auction Application Service.

  The auction system business domain lives in this application.

  Exposes API to clients such as the `AuctionWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Auction.Repo, []),
    ], strategy: :one_for_one, name: Auction.Supervisor)
  end
end
