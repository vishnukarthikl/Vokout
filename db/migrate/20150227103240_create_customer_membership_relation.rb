class CreateCustomerMembershipRelation < ActiveRecord::Migration
  def change
    create_table :customers_memberships, id: false do |t|
      t.belongs_to :customer, index: true
      t.belongs_to :membership, index: true
    end
  end
end
