defmodule AuctionWeb.AuthenticationControllerTest do
  use AuctionWeb.ConnCase
  alias DB.Accounts
  alias DB.Accounts.{User}
  alias DB.Repo

  require Ueberauth
  require Logger

  @create_attrs %{
    email: "test@test.com",
    image: "some image",
    name: "tester",
    nickname: "tester",
    provider: "wechat",
    refresh_token: "some refresh_token",
    token: "some token",
    token_secret: "some token_secret",
    uid: "some uid",
    union_id: "the_union_id"
  }

  @update_attrs %{
    email: "some updated email",
    image: "some updated image",
    name: "some updated name",
    nickname: "some updated nickname",
    provider: "some updated provider",
    refresh_token: "some updated refresh_token",
    token: "some updated token",
    token_secret: "some updated token_secret",
    uid: "some updated uid",
    union_id: "some updated union_id",
    user_id: 43
  }

  @invalid_attrs %{
    email: nil,
    image: nil,
    name: nil,
    nickname: nil,
    provider: nil,
    refresh_token: nil,
    token: nil,
    token_secret: nil,
    uid: nil,
    union_id: nil,
    user_id: nil
  }

  @user_attrs %{
    email: "test@test.com",
    nickname: "tester"
  }

  @wechat_auth %Ueberauth.Auth{
    credentials: %Ueberauth.Auth.Credentials{
      expires: false,
      expires_at: nil,
      other: %{},
      refresh_token: nil,
      scopes: [""],
      secret: nil,
      token:
        "{\"access_token\":\"6_kWAreWiyqGnPNLG5jFXOIlUDSxsNca11lfm-iisGmtQ_vSju3EUMWjsv_sIaIShCFNunpQub8KUhL08Y1RB_Gw\",\"expires_in\":7200,\"refresh_token\":\"6_Lwo_qEWptm_lNpaRhwBq-5cDdLo0dm2LIPqjFkS_By9GjOar4_9jGCSOwjMbq4dzn74_OzuEOIpilky2RaqFLg\",\"openid\":\"o4VnTwMHwR3bex-rikSbEsx2ksi4\",\"scope\":\"snsapi_userinfo\"}",
      token_type: "Bearer"
    },
    extra: %Ueberauth.Auth.Extra{
      raw_info: %{
        token: %OAuth2.AccessToken{
          access_token:
            "{\"access_token\":\"6_kWAreWiyqGnPNLG5jFXOIlUDSxsNca11lfm-iisGmtQ_vSju3EUMWjsv_sIaIShCFNunpQub8KUhL08Y1RB_Gw\",\"expires_in\":7200,\"refresh_token\":\"6_Lwo_qEWptm_lNpaRhwBq-5cDdLo0dm2LIPqjFkS_By9GjOar4_9jGCSOwjMbq4dzn74_OzuEOIpilky2RaqFLg\",\"openid\":\"o4VnTwMHwR3bex-rikSbEsx2ksi4\",\"scope\":\"snsapi_userinfo\"}",
          expires_at: nil,
          other_params: %{},
          refresh_token: nil,
          token_type: "Bearer"
        },
        user: %{
          "city" => "Shenzhen",
          "country" => "CN",
          "headimgurl" =>
            "http://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83eqNeOZ9Nibv3jbicE8ztp6ul1ic6S4F1bM1wPrU2iaOazL7nGbSZpIr00tom8fnqGSKP7sOanGOBvLJwQ/132",
          "language" => "zh_CN",
          "nickname" => "Edward",
          "openid" => "o4VnTwMHwR3bex-rikSbEsx2ksi4",
          "privilege" => [],
          "province" => "Guangdong",
          "sex" => 1,
          "unionid" => "the_union_id"
        }
      }
    },
    info: %Ueberauth.Auth.Info{
      description: nil,
      email: nil,
      first_name: nil,
      image:
        "http://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83eqNeOZ9Nibv3jbicE8ztp6ul1ic6S4F1bM1wPrU2iaOazL7nGbSZpIr00tom8fnqGSKP7sOanGOBvLJwQ/132",
      last_name: nil,
      location: nil,
      name: nil,
      nickname: "Edward",
      phone: nil,
      urls: %{}
    },
    provider: :wechat,
    strategy: Ueberauth.Strategy.Wechat,
    uid: "o4VnTwMHwR3bex-rikSbEsx2ksi4"
  }

  def fixture(:authentication) do
    {:ok, authentication} = Accounts.create_authentication(@create_attrs)
    authentication
  end

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@user_attrs)
    user
  end

  def fixture(:user_with_auth) do
    auth = fixture(:authentication)
    user = fixture(:user)

    {:ok, auth} = Accounts.update_authentication(auth, %{user_id: user.id})

    user
    |> Repo.preload(:authentications)
  end

  defp create_authentication(_) do
    authentication = fixture(:authentication)
    {:ok, authentication: authentication}
  end

  describe "new authentication" do
    test "create new user", %{conn: conn} do
      assert Accounts.get_authentication(uid: "o4VnTwMHwR3bex-rikSbEsx2ksi4") == nil

      conn =
        conn
        |> assign(:ueberauth_auth, @wechat_auth)
        |> get(auth_path(conn, :callback, :wechat), %{"code" => "test_code"})

      assert html_response(conn, 302)
      assert Accounts.get_authentication(uid: "o4VnTwMHwR3bex-rikSbEsx2ksi4") != nil
    end

    test "associate existing user with union_id", %{conn: conn} do
      assert Accounts.get_authentication(uid: "o4VnTwMHwR3bex-rikSbEsx2ksi4") == nil
      user = fixture(:user_with_auth)
      user_count = User |> Repo.aggregate(:count, :id)

      conn =
        conn
        |> assign(:ueberauth_auth, @wechat_auth)
        |> get(auth_path(conn, :callback, :wechat), %{"code" => "test_code"})
        assert html_response(conn, 302)

      auth = Accounts.get_authentication(uid: "o4VnTwMHwR3bex-rikSbEsx2ksi4")
      assert auth != nil
      assert user_count == User |> Repo.aggregate(:count, :id)
      assert auth.user_id == user.id
    end
  end
end
