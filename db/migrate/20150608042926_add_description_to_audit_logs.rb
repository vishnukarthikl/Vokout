class AddDescriptionToAuditLogs < ActiveRecord::Migration
  def change
    add_column :audit_logs, :description, :string
  end
end
