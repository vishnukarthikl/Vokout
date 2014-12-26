class CreateFacilities < ActiveRecord::Migration
  def change
    create_table :facilities do |t|
      t.text :name
      t.references :owner, index: true

      t.timestamps null: false
    end
    add_foreign_key :facilities, :owners
  end
end
