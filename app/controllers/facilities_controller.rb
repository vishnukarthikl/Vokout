class FacilitiesController < ApplicationController

  before_filter :authenticate

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

  private
  def set_owner
    @owner = Owner.find(params[:owner_id])
  end

  def facility_params
    params.require(:facility).permit([:name, :address, :phone])
  end
end
