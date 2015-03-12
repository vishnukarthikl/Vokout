class DashboardController < ApplicationController
  before_action :set_owner_facility

  include AccountsetupHelper

  def main
    unless is_account_setup(@facility)
      redirect_to setup_path
    end
  end

  def members
    @owner.facility
  end

  private
  def set_owner_facility
    @owner = current_owner
    @facility = @owner.facility
  end
end
