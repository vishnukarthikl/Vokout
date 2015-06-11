class AddCollaboratorToOwners < ActiveRecord::Migration
  def change
    add_column :owners, :is_collaborator, :boolean
    remove_foreign_key :facilities, :owners
    add_foreign_key :owners, :facilities
    add_reference :owners, :facility, index:true
    remove_column :facilities, :owner_id
  end
end
