class RemoveCategoryFromRevenue < ActiveRecord::Migration
  def change
    remove_column :revenues, :category
  end
end
