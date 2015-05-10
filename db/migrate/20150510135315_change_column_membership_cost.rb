class ChangeColumnMembershipCost < ActiveRecord::Migration
  def change
    change_column :memberships, :cost, :integer
  end
end
