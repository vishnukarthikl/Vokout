class AccountsetupController < ApplicationController
  before_filter :authenticate

  before_action :set_facility

  def facility
    @facility = @owner.facility
    if @facility.nil?
      render 'accountsetup/facilitysetup'
    elsif @facility.memberships.empty?
      @membership = @facility.memberships.build
      render 'memberships/new'
    else
      render 'owners/dashboard'
    end
  end


  private
  def set_facility
    @owner = Owner.find(params[:id])
  end

end
