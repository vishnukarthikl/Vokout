class FacilitiesController < ApplicationController

  before_action :set_owner, only: [:create, :show]
  before_filter :authenticate

  def setup
    render 'facilities/setup'
  end

  def create
    @owner = current_owner
    @facility = @owner.build_facility(facility_params)
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
    @owner = current_owner || Owner.find(params[:owner_id])
  end

  def facility_params
    params.require(:facility).permit([:name, :address, :phone])
  end
end
