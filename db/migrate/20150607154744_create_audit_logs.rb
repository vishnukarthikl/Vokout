class CreateAuditLogs < ActiveRecord::Migration
  def change
    create_table :audit_logs do |t|
      t.references :facility, index: true
      t.timestamps null: false
      t.date :date
    end
    add_belongs_to :audit_logs, :auditable, polymorphic: true
    add_foreign_key :revenues, :facilities
  end
end
