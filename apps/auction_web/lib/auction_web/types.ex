defmodule AuctionWeb.Types do
  use AuctionWeb, :type
  import Ecto.Query
  use Absinthe.Ecto, repo: DB.Repo

  object :accounts_user do
    field(:nickname, :string)
    field(:id, :id)
    field(:username, :string)
    field(:telephone, :string)
    field(:authentications, list_of(:authentication), resolve: assoc(:authentications))
  end

  object :authentication do
    field(:id, :id)
    field(:uid, :string)
    field(:email, :string)
    field(:image, :string)
    field(:name, :string)
    field(:nickname, :string)
    field(:provider, :string)
    field(:refresh_token, :string)
    field(:token, :string)
    field(:token_secret, :string)
    field(:user, :accounts_user, resolve: assoc(:user))
  end
end
