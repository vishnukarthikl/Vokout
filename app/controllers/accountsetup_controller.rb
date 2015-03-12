class AccountsetupController < ApplicationController
  before_filter :authenticate

  before_action :set_owner

  def setup
    render 'accountsetup/setup'
  end

  def setup_status
    @owner = Owner.includes(facility: [members: [subscriptions: :membership]]).find(@owner.id)
    @facility = @owner.facility
  end

  private
  def set_owner
    @owner = current_owner
  end

end
