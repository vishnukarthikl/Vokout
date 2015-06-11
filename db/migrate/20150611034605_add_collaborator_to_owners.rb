class AddCollaboratorToOwners < ActiveRecord::Migration
  def change
    add_column :owners, :is_collaborator, :boolean
    remove_foreign_key :facilities, :owners
    add_column :owners, :facility_id, :integer
    remove_column :facilities, :owner_id
  end
end
