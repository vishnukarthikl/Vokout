class AddAddressAndPhoneToFacility < ActiveRecord::Migration
  def change
    add_column :facilities, :address, :text
    add_column :facilities, :phone, :string
  end
end
