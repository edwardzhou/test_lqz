defmodule DB.EctoEnums do
  import EctoEnum

  defenum AuctionItemStateEnum, draft: 0, ready: 1, ongoing: 2, abandoned: 3, completed: 4

  defenum AuctionStateEnum, draft: 0, ready: 1, ongoing: 2, ended: 3
end