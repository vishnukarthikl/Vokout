class AddDeactivatedToOwners < ActiveRecord::Migration
  def change
    add_column :owners, :deactivated, :boolean
  end
end
