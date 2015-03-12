class RenameCustomerToMember < ActiveRecord::Migration
  def change
    rename_table :customers, :members
  end
end
