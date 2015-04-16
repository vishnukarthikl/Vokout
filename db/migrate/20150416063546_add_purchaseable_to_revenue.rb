class AddPurchaseableToRevenue < ActiveRecord::Migration
  def change
    add_belongs_to :revenues, :purchasable, polymorphic: true
    add_index :revenues, [:purchasable_id, :purchasable_type]
  end

end
