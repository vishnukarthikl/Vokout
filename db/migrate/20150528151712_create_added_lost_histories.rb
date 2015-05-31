class CreateAddedLostHistories < ActiveRecord::Migration
  def change
    create_table :added_lost_histories do |t|
      t.references :member, index: true
      t.boolean :is_lost, index: true
      t.date :since, index: true
      t.timestamps null: false
    end
    add_foreign_key :added_lost_histories, :members
  end
end
