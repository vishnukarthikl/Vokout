class AddExpiresOnToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :expires_on, :date
  end
end
