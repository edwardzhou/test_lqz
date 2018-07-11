defmodule AuctionWeb.Resolvers.UpdateRealnameResolver do
  @moduledoc """
  实名认证更新解释器
  """

  require IEx

  alias DB.Accounts

  @doc """
  提交实名认证信息
  """
  def apply_verification(_parent, args, _resolution) do
    # IEx.pry
    # IO.puts("[apply_verification] _resolution: #{inspect _resolution}")
    IO.puts("[apply_verification] args: #{inspect args}")
    input = args[:input]
    user = Accounts.get_user(String.to_integer(input[:user_id]))
    IO.puts("[apply_verification] user: #{inspect user}")

    case Accounts.get_realname_verification(user.id) do
      nil -> 
        {:ok, realname} = Accounts.create_realname_verification(%{
          user_id: user.id,
          realname: input[:realname],
          id_no: input[:id_no],
          state: 1
        })
      rn ->
        {:ok, realname} = 
          rn 
          |> Accounts.update_realname_verification(%{
            user_id: user.id,
            realname: input[:realname],
            id_no: input[:id_no]
          })
    end
    
    {:ok, realname}
  end
end
