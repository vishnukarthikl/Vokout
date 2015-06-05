class CreateActiveMembersHistory < ActiveRecord::Migration
  def change
    create_table :active_members_histories do |t|
      t.references :facility, index: true
      t.integer :count
      t.integer :total
      t.date :in
    end
    add_foreign_key :active_members_histories, :facilities
    add_index :active_members_histories, :in
  end
end
