class AddExtendedTillToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :extended_till, :date
  end
end
