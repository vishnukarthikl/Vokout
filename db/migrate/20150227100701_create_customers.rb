class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :phone_number
      t.string :email
      t.boolean :is_male
      t.date :date_of_birth
      t.string :occupation
      t.text :address
      t.string :pincode
      t.string :emergency_number
      t.timestamps null: false

      t.references :facility, index: true
    end
    add_foreign_key :customers, :facilities
  end
end
