class ChangeColumnRevenueValue < ActiveRecord::Migration
  def change
    change_column :revenues, :value, :integer
  end
end
