class AddInactiveToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :inactive, :boolean
  end
end
