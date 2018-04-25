defmodule DB.EctoEnums do
  import EctoEnum

  defenum AuctionItemStateEnum, draft: 0, ready: 1, ongoing: 2, abandoned: 3, completed: 4
end