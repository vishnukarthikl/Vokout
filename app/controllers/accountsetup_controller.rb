class AccountsetupController < ApplicationController
  before_filter :authenticate

  before_action :set_owner

  def facility
      render 'accountsetup/facilitysetup'
  end


  private
  def set_owner
    @owner = Owner.find(params[:id])
  end

end
