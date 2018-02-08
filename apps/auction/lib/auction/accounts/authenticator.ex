defmodule Auction.Accounts.Authenticator do
  alias Auction.Accounts
  alias Auction.Accounts.Authentication
  alias Auction.Repo
  import Ecto.Query

  def authenticate(%{} = _params) do
    case Authentication
          |> where([au], au.uid == ^_params.uid)
          |> Repo.one do
      nil -> Accounts.create_authentication(_params)
      prior_auth -> {:ok, prior_auth}
    end
    
    #Accounts.create_authentication(_params)
    # {:ok, %Authentication{}}
  end
end