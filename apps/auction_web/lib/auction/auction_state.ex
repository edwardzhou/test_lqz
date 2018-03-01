defmodule AuctionWeb.Auction.AuctionState do
  alias AuctionWeb.Auction.AuctionState

  # 最高出价
  defstruct top_bid: %{bidder: nil, bid: 0},
            # 拍卖id
            auction_id: 1,
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
            increase_rates: [0.1, 0.2, 0.5], # 10%, 20%. 50%
            increases: [100, 200, 500],
            # 最后出价时间
            bid_at: NaiveDateTime.utc_now,
            status: :on_going,
            # 倒计时
            countdown: 30

  def new_state(id, base_bid) do
    %AuctionState{auction_id: id, top_bid: %{bidder: nil, bid: base_bid}}
    |> update_increases
  end

  def push_back_state(state) do
    state
    |> Map.from_struct()
    |> Map.delete(:participiants)
    |> Map.delete(:bidders)
    |> Map.delete(:last_timer_id)
    |> put_in([:bid_list], Enum.slice(state.bid_list, 0..9))
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
      when increase != i1 and 
           increase != i2 and
           increase != i3 do
    {:error_stale_bid, state}
  end
  def bid(%{status: status} = state, _) when status != :on_going do
    {:error_stale_bid, state}
  end
  # def bid(%{bid_at: bid_at} = state, _) do 
  # end


  def bid(state, params) do
    token_id = params.token_id
    bidder_name = params.bidder_name
    bid_base = params.bid_base
    increase = params.increase
    new_bid = bid_base + increase

    bid_params = {bidder_name, new_bid}

    state =
      state
      |> add_bidder(bidder_name)
      |> update_top_bid(bid_params)
      |> update_participants(bid_params)
      |> update_bidders(bid_params)
      |> add_to_bid_list(bid_params)
      |> update_bid_count()
      |> update_bidder_count()
      |> inc_token_id()
      |> update_bid_at()
      |> update_increases()

    {:ok, state}
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
    %{auction | bid_at: NaiveDateTime.utc_now}
  end

  def update_increases(%{top_bid: %{bid: last_bid}} = auction) do
    base = div(last_bid, 500) * 500
    base = case rem(last_bid, 500) do
      0 -> base
      _ -> base + 500
    end
    increases = Enum.map([base * 0.1, base * 0.2, base * 0.5], &(trunc(&1)))
    %{auction | increases: increases}
  end

end
