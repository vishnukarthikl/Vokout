class AccountsetupController < ApplicationController
  before_filter :authenticate

  before_action :set_owner

  def facility
    @facility = @owner.facility
    if @facility.nil?
      render 'accountsetup/facilitysetup'
    elsif @facility.memberships.empty?
      @membership = @facility.memberships.build
      render 'memberships/new'
    elsif @facility.customers.empty?
      @customer = @facility.customers.build
      render 'customers/new'
    else
      render 'owners/dashboard'
    end
  end


  private
  def set_owner
    @owner = Owner.find(params[:id])
  end

end
