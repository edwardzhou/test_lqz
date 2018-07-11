defmodule AuctionAdmin.ExAdmin.Authentication do
  use ExAdmin.Register

  alias DB.Accounts.Authentication
  import AuctionAdmin.Gettext

  register_resource Authentication do
    scope :all, default: true

    index do
      column :id
      column :email, label: gettext("Email")
      column :image, [label: gettext("headicon")], fn(authentication) ->
        img src: authentication.image
      end
      column :name, label: gettext("Name")
      column :nickname, label: gettext("Nick Name")
      column :provider, label: gettext("Provider")
      column :uid, label: gettext("uid")
      column :union_id, label: gettext("union id")
      column :inserted_at, label: gettext "created at"
      column :updated_at, label: gettext("updated at")
      actions()
    end


  end
end
