defmodule AuctionAdmin.ExAdmin.User do
  use ExAdmin.Register
  import AuctionAdmin.Gettext
  alias DB.Accounts.User

  register_resource User do
    menu label: gettext("Users")

    scope :all, default: true

    index do
      column :id
      column :username, label: gettext("User Name")
      column :nickname, label: gettext("Nick Name")
      column :telephone, label: gettext("Telephone")
      column :email, label: gettext("Email")
      actions()
    end
    
  end
end