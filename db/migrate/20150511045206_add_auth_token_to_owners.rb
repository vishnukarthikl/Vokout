class AddAuthTokenToOwners < ActiveRecord::Migration
  def change
    add_column :owners, :auth_token, :string
  end
end
