class AddInactiveToMembers < ActiveRecord::Migration
  def change
    add_column :members, :inactive, :boolean, :default => false
  end
end
