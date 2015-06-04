class FacilitiesController < ApplicationController

  before_filter :authenticate
  before_action :set_owner, only: [:create, :show]

  def setup
    render 'facilities/setup'
  end

  TRIAL_PERIOD = 1.months

  def create
    @owner = current_owner
    @facility = @owner.build_facility(facility_params)
    @facility.expires_on = TRIAL_PERIOD.since
    respond_to do |format|
      if @facility.save
        format.html {
          flash[:success] = "#{@facility.name} has been created"
          redirect_to dashboard_owner_path(@owner)
        }
        format.json { render json: @facility, status: :ok }
      else
        format.html { render 'owner#dashboard' }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @owner = Owner.eager_load(facility: [members: [subscriptions: :membership], revenues: [], memberships: []]).find(@owner.id)
    @facility = @owner.facility
  end

  private
  def set_owner
    @owner = current_owner
  end

  def facility_params
    params.require(:facility).permit([:name, :address, :phone])
  end
end
