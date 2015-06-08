class AuditLogsController < ApplicationController
  before_filter :authenticate
  before_action :set_facility

  def index
    @audit_logs = @facility.audit_logs.order('date desc')
  end

  private
  def set_facility
    @facility = Facility.find(facility_id)
  end

  def facility_id
    current_owner.facility.id
  end

end
