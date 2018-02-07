defmodule Auction.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Auction.Accounts.User


  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :nickname, :string
    field :telephone, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :nickname, :encrypted_password, :telephone, :email])
    |> validate_required([:username, :nickname, :encrypted_password, :telephone, :email])
  end
end
