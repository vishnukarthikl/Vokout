class CreateRevenues < ActiveRecord::Migration
  def change
    create_table :revenues do |t|
      t.string :category
      t.decimal :value
      t.date :date
      t.references :facility, index: true
      t.references :member, index: true
      t.timestamps null: false
    end
    add_foreign_key :revenues, :facilities
    add_foreign_key :revenues, :members
  end
end
