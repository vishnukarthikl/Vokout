class DashboardController < ApplicationController
  before_filter :authenticate

  before_action :set_owner_facility

  include AccountsetupHelper

  def overview
    unless is_account_setup(@facility)
      redirect_to setup_path
    end
  end

  def members
  end

  private
  def set_owner_facility
    @owner = current_owner
    @facility = @owner.facility
  end
end
