class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :name
      t.integer :cost
      t.date :date
      t.string :purchase_type
      t.references :member, index: true
      t.timestamps null: false
    end
    add_foreign_key :purchases, :members
  end
end
