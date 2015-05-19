class AddTemporaryToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :temporary, :boolean
  end
end
