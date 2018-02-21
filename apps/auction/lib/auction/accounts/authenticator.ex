defmodule Auction.Accounts.Authenticator do
  alias Auction.Accounts

  def authenticate(%{uid: uid} = params) do
    case Accounts.get_authentication(uid: uid) do
      nil -> 
        params
        |> Accounts.create_authentication
        |> Tuple.to_list
        |> List.last
        |> Accounts.user_from_auth
      prior_auth -> 
        {:ok, Accounts.get_user!(prior_auth.user_id)}
    end
  end 
end