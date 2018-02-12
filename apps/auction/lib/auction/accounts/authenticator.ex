defmodule Auction.Accounts.Authenticator do
  alias Auction.Accounts
  alias Auction.Accounts.Authentication
  alias Auction.Accounts.User
  alias Auction.Repo
  import Ecto.Query

  def authenticate(%{} = params) do
    case find_auth(params.uid) do
      nil -> 
        {:ok, auth} = Accounts.create_authentication(params)
        Accounts.new_user_from_auth(auth)
      prior_auth -> 
        {:ok, Accounts.get_user!(prior_auth.user_id)}
    end
  end

  def find_auth(uid) do
    Authentication
    |> where([auth], auth.uid == ^uid)
    |> Repo.one
  end
  
end