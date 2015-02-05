class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.string :name
      t.integer :duration
      t.decimal :cost
      t.belongs_to :facility, index: true

      t.timestamps null: false
    end
  end
end
