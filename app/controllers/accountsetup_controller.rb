class AccountsetupController < ApplicationController
  before_filter :authenticate

  before_action :set_owner

  def facility
    render 'accountsetup/facilitysetup'
  end

  def setup_status
    @facility = @owner.facility
  end

  private
  def set_owner
    @owner = current_owner
  end

end
