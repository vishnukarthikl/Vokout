class DashboardController < ApplicationController
  before_filter :authenticate
  before_filter :check_collaborator, only: [:overview, :memberships, :history]

  before_action :set_owner_facility

  include AccountsetupHelper

  def overview
    if !is_account_setup(@facility)
      redirect_to setup_path
    end
  end

  def members
  end

  def memberships
  end

  def history

  end

  private
  def set_owner_facility
    @owner = current_owner
    @facility = @owner.facility
  end
end
