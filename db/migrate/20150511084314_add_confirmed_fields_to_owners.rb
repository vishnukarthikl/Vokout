class AddConfirmedFieldsToOwners < ActiveRecord::Migration
  def change
    add_column :owners, :confirmation_code, :string
    add_column :owners, :confirmed, :boolean
  end
end
