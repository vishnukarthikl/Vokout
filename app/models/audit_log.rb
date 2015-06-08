class AuditLog < ActiveRecord::Base
  belongs_to :facility
  belongs_to :auditable, polymorphic: true
end
