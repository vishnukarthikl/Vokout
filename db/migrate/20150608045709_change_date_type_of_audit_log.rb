class ChangeDateTypeOfAuditLog < ActiveRecord::Migration
  def change
    change_column :audit_logs, :date, :datetime
  end
end
