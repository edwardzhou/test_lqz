defmodule AuctionWeb.Auction.AuctionState do
  alias AuctionWeb.Auction.AuctionState
  use Timex

  # 最高出价
  defstruct top_bid: %{bidder: nil, bid: 0},
            # 拍卖id
            auction_id: 1,
            # 拍卖项id
            auction_item_id: 1,
            # 全部出价信息
            bidders: %{},
            # 出价列表
            bid_list: [],
            # 参与人 (围观 + 出价)
            participants: %{},
            # 参与人数
            participant_count: 0,
            last_timer_id: nil,
            # 出价令牌
            next_token_id: 1,
            # 出价人数
            bidder_count: 0,
            # 出价次数
            bid_count: 0,
            # 加价比例
            # 10%, 20%. 50%
            increase_rates: [0.1, 0.2, 0.5],
            increases: [100, 200, 500],
            price_starts: 1000,
            # 最后出价时间
            bid_at: nil,
            status: :pending,
            commission_rate: 3,
            commissions: 0,
            withdraws: %{},
            # 倒计时
            countdown: 30

  def new_state(id, base_bid) do
    %AuctionState{
      auction_id: id,
      top_bid: %{bidder: nil, bid: base_bid},
      price_starts: base_bid
    }
    |> update_increases
    |> update_commissions()
  end

  def start(state) do
    %{state | bid_at: Timex.local(), status: :on_going}
  end

  def push_back_state(state) do
    state
    |> Map.from_struct()
    |> Map.delete(:participiants)
    |> Map.delete(:bidders)
    |> Map.delete(:last_timer_id)
    |> put_in([:bid_list], Enum.slice(state.bid_list, 0..9))
  end

  def is_on_going(%{status: status} = state), do: status == :on_going

  def countdown(state) do
    %{bid_at: last_bid_at} = state

    case Timex.diff(Timex.local(), last_bid_at, :seconds) do
      seconds when seconds >= 30 ->
        %{state | status: :closed}
      _ ->
        state
    end
  end

  def add_bidder(%{participants: participants} = state, bidder_name) do
    case participants[bidder_name] do
      nil ->
        p = Map.put(participants, bidder_name, %{bid: 0})
        %{state | participants: p, participant_count: Map.size(p)}

      _ ->
        state
    end
  end

  def bid(%{next_token_id: next_token_id} = state, %{token_id: token_id})
      when token_id != next_token_id do
    {:error_stale_token_id, state}
  end

  def bid(%{top_bid: %{bidder: bidder}} = state, %{bidder_name: bidder_name})
      when bidder_name == bidder do
    {:error_duplicated_bid, state}
  end

  def bid(%{top_bid: %{bid: last_bid}} = state, %{bid_base: bid})
      when bid != last_bid do
    {:error_stale_bid, state}
  end

  def bid(%{increases: [i1, i2, i3]} = state, %{increase: increase})
      when increase != i1 and increase != i2 and increase != i3 do
    {:error_stale_bid, state}
  end

  def bid(%{status: status} = state, _) when status != :on_going do
    {:error_closed, state}
  end

  def bid(state, params) do
    token_id = params.token_id
    bidder_name = params.bidder_name
    bid_base = params.bid_base
    increase = params.increase
    new_bid = bid_base + increase

    bid_params = {bidder_name, new_bid}

    %{bid_at: last_bid_at} = state

    case Timex.diff(Timex.local(), last_bid_at, :seconds) do
      seconds when seconds < 30 ->
        {:ok, update_state(state, bid_params)}

      {:error, :invalid_date} ->
        {:ok, update_state(state, bid_params)}

      _ ->
        {:error_closed, state}
    end
  end

  # def withdraw(
  #       %{top_bid: %{bidder: bidder, bid: bid}} = state,
  #       %{bidder_name: bidder_name, bid: bid} = params
  #     )
  #     when bidder != bidder_name do
  #   {:error, state}
  # end

  def withdraw(
        %{next_token_id: next_token_id} = state,
        %{token_id: token_id} = params
      )
      when next_token_id != token_id do
    {:error, state}
  end

  def withdraw(
        %{bid_list: []} = state,
        params
      ) do
    {:error, state}
  end

  def withdraw(
        %{top_bid: %{bidder: bidder, bid: top_bid}} = state,
        %{bidder_name: bidder_name, bid: bid} = params
      )
      when bidder != bidder_name
      when top_bid != bid do
    {:error, state}
  end

  # def withdraw(
  #       %{bid_at: bid_at} = state,
  #       params
  #     )
  #     when Timex.diff(Timex.local(), bid_at, :seconds) >= 10do
  #   {:error, state}
  # end

  def withdraw(state, params) do
    {first, second} = top_two(state.bid_list)

    cond do
      Timex.diff(Timex.local(), state.bid_at, :seconds) >= 10 ->
        {:error, state}

      state.withdraws[first.bidder] != nil ->
        {:error_withdraw_once, state}

      true ->
        prev_bid =
          case second do
            nil -> {nil, state.price_starts}
            %{bidder: bidder, bid: bid} -> {bidder, bid}
          end

        state =
          state
          |> update_top_bid(prev_bid)
          |> add_to_bid_list({first.bidder, -first.bid})
          |> add_to_withdraws({first.bidder, first.bid})
          |> update_bidder_count()
          |> inc_token_id()
          |> update_bid_at()
          |> update_increases()
          |> update_commissions()

        {:ok, state}
    end
  end

  def top_two(list) when not is_list(list), do: {nil, nil}
  def top_two([] = list), do: {nil, nil}
  def top_two([first] = list), do: {first, nil}
  def top_two([first, second | _] = list), do: {first, second}

  def update_state(state, {bidder_name, _} = bid_params) do
    state
    |> add_bidder(bidder_name)
    |> update_top_bid(bid_params)
    |> update_participants(bid_params)
    |> update_bidders(bid_params)
    |> add_to_bid_list(bid_params)
    # |> add_to_withdraws({bidder_name, -1})
    |> update_bid_count()
    |> update_bidder_count()
    |> inc_token_id()
    |> update_bid_at()
    |> update_increases()
    |> update_commissions()
  end

  def update_top_bid(auction, {bidder_name, new_bid}) do
    %{auction | top_bid: %{bidder: bidder_name, bid: new_bid}}
  end

  def update_participants(%{participants: p} = auction, {bidder_name, new_bid}) do
    %{auction | participants: Map.put(p, bidder_name, %{bid: new_bid})}
  end

  def update_bidders(auction, {bidder_name, new_bid}) do
    bidders = auction.bidders
    %{auction | bidders: Map.put(bidders, bidder_name, %{bid: new_bid})}
  end

  def add_to_bid_list(state, {bidder_name, new_bid}) do
    %{state | bid_list: [%{bidder: bidder_name, bid: new_bid} | state.bid_list]}
  end

  def add_to_withdraws(state, {bidder_name, bid}) do
    withdraws =
      state.withdraws
      |> Map.put(bidder_name, %{bid: bid})

    %{state | withdraws: withdraws}
  end

  def update_bid_count(state) do
    %{state | bid_count: length(state.bid_list)}
  end

  def update_bidder_count(state) do
    %{state | bidder_count: Map.size(state.bidders)}
  end

  def inc_token_id(%{next_token_id: token_id} = auction) do
    %{auction | next_token_id: token_id + 1}
  end

  def update_bid_at(%{bid_at: _bid_at} = auction) do
    %{auction | bid_at: Timex.local()}
  end

  def update_increases(%{top_bid: %{bid: last_bid}} = auction)
      when last_bid == nil or last_bid < 2_000 do
    %{auction | increases: [20, 100, 200]}
  end

  def update_increases(%{top_bid: %{bid: last_bid}} = auction)
      when last_bid < 5_000 do
    %{auction | increases: [50, 200, 500]}
  end

  def update_increases(%{top_bid: %{bid: last_bid}} = auction)
      when last_bid < 10_000 do
    %{auction | increases: [100, 500, 1_000]}
  end

  def update_increases(%{top_bid: %{bid: last_bid}} = auction)
      when last_bid < 50_000 do
    %{auction | increases: [200, 1_000, 2_000]}
  end

  def update_increases(%{top_bid: %{bid: last_bid}} = auction)
      when last_bid < 100_000 do
    %{auction | increases: [500, 2_000, 5_000]}
  end

  def update_increases(%{top_bid: %{bid: last_bid}} = auction) do
    %{auction | increases: [1_000, 5_000, 10_000]}
  end

  # def update_increases(%{top_bid: %{bid: last_bid}} = auction) do
  #   base = div(last_bid, 500) * 500

  #   base =
  #     case rem(last_bid, 500) do
  #       0 -> base
  #       _ -> base + 500
  #     end

  #   increases = Enum.map([base * 0.1, base * 0.2, base * 0.5], &trunc(&1))
  #   %{auction | increases: increases}
  # end

  def update_commissions(%{top_bid: %{bid: last_bid}} = state) do
    commissions = div(last_bid * state.commission_rate, 100)
    %{state | commissions: commissions}
  end
end
