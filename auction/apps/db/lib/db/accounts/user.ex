defmodule DB.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias DB.Accounts.User
  alias DB.Repo
  alias DB.Accounts.Authentication


  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :nickname, :string
    field :telephone, :string
    field :username, :string

    timestamps()

    has_many :authentications, Authentication
  end

  @doc false
  def changeset(%User{} = user, %Authentication{} = authentication) do
    attrs = %{
      nickname: authentication.nickname,
      email: authentication.email
    }

    changeset(user, attrs)
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :nickname, :encrypted_password, :telephone, :email])
    |> validate_required([:nickname])
    |> unsafe_validate_unique([:username], Repo)
    |> unsafe_validate_unique([:telephone], Repo)
  end
end
