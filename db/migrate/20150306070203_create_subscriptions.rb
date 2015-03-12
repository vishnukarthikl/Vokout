class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.date :start_date
      t.references :membership, index: true
      t.references :member, index: true
      t.timestamps null: false
    end
    add_foreign_key :subscriptions, :memberships
    add_foreign_key :subscriptions, :members
  end
end
