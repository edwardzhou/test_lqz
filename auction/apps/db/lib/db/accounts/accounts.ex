defmodule DB.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto
  import Ecto.Query, warn: false
  alias DB.Repo

  alias DB.Accounts.User
  alias DB.Accounts.RealnameVerification

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)

  def find_user_by_nickname(nickname) do
    User
    |> where(nickname: ^nickname)
    |> Repo.all
    |> List.first
  end

  def find_or_initialize_user_by_nickname(nickname) do
    case find_user_by_nickname(nickname) do
      nil -> 
        {:ok, new_user} = create_user(%{nickname: nickname})
        new_user
      
      user -> user
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias DB.Accounts.Authentication

  @doc """
  Returns the list of authentications.

  ## Examples

      iex> list_authentications()
      [%Authentication{}, ...]

  """
  def list_authentications do
    Repo.all(Authentication)
  end

  @doc """
  Gets a single authentication.

  Raises `Ecto.NoResultsError` if the Authentication does not exist.

  ## Examples

      iex> get_authentication!(123)
      %Authentication{}

      iex> get_authentication!(456)
      ** (Ecto.NoResultsError)

  """
  def get_authentication!(id) when is_integer(id), do: Repo.get!(Authentication, id)

  @doc """
  通过uid获取认证
  """
  def get_authentication(uid: nil), do: nil

  def get_authentication(uid: uid) do
    Authentication |> Repo.get_by(uid: uid)
  end

  @doc """
  通过union_id获取认证
  """
  def get_authentication(union_id: nil), do: nil

  def get_authentication(union_id: union_id) do
    Authentication
    |> where(union_id: ^union_id)
    |> first
    |> Repo.one()
  end

  @doc """
  Creates a authentication.

  ## Examples

      iex> create_authentication(%{field: value})
      {:ok, %Authentication{}}

      iex> create_authentication(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_authentication(attrs \\ %{}) do
    %Authentication{}
    |> Authentication.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a authentication.

  ## Examples

      iex> update_authentication(authentication, %{field: new_value})
      {:ok, %Authentication{}}

      iex> update_authentication(authentication, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_authentication(%Authentication{} = authentication, attrs) do
    authentication
    |> Authentication.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Authentication.

  ## Examples

      iex> delete_authentication(authentication)
      {:ok, %Authentication{}}

      iex> delete_authentication(authentication)
      {:error, %Ecto.Changeset{}}

  """
  def delete_authentication(%Authentication{} = authentication) do
    Repo.delete(authentication)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking authentication changes.

  ## Examples

      iex> change_authentication(authentication)
      %Ecto.Changeset{source: %Authentication{}}

  """
  def change_authentication(%Authentication{} = authentication) do
    Authentication.changeset(authentication, %{})
  end

  @doc """
  create new user from authentication
  """
  def new_user_from_auth(%Authentication{} = authentication) do
    {:ok, new_user} = create_user(Authentication.to_user_attributes(authentication))
    {:ok, _} = update_authentication(authentication, %{user_id: new_user.id})
    {:ok, new_user}
  end

  @doc """
  create new user from authentication
  """
  def user_from_auth(%Authentication{:union_id => union_id} = auth, nil) do
    {:ok, user} = create_user(auth)
    {:ok, _} = update_authentication(auth, %{user_id: user.id})
    {:ok, user}
  end
  def user_from_auth(%Authentication{:union_id => union_id} = auth, prior_auth) do
    {:ok, _} = update_authentication(auth, %{user_id: prior_auth.user_id})
    {:ok, prior_auth |> assoc(:user) |> Repo.one()}
  end

  def get_realname_verification(user_id) do
    RealnameVerification 
    |> where(user_id: ^user_id)
    |> Repo.all
    |> List.first
  end

  def create_realname_verification(attrs) do
    %RealnameVerification{}
    |> RealnameVerification.changeset(attrs)
    |> Repo.insert()
  end

  def update_realname_verification(%RealnameVerification{} = rn, attrs) do
    rn
    |> RealnameVerification.changeset(attrs)
    |> Repo.update()
  end
end
