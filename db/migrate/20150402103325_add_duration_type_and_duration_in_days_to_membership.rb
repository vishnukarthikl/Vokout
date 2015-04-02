class AddDurationTypeAndDurationInDaysToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :duration_type, :string
    add_column :memberships, :duration_in_days, :integer
  end
end
