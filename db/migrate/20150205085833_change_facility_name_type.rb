class ChangeFacilityNameType < ActiveRecord::Migration
  def change
    change_column :facilities, :name, :string
  end
end
