class MembershipsController < ApplicationController

  before_filter :authenticate

  before_action :set_facility, only: [:create, :new, :index]
  before_action :set_membership, only: [:edit, :destroy, :update]

  def index
    respond_to do |format|
      format.html { redirect_to dashboard_memberships_path }
      format.json do
        @memberships = @facility.memberships.all
        render @memberships
      end
    end
  end

  def new
    @membership = @facility.memberships.build
  end

  def create
    @membership = @facility.memberships.build(membership_params)
    respond_to do |format|
      if !@facility.memberships.exists?({name: @membership.name, temporary: nil})
        if @membership.save
          format.html {
            flash[:success] = "#{@membership.name} has been created"
            redirect_to facility_memberships_path(@facility)
          }
          format.json { render json: @membership, status: :ok }
        else
          format.html { render :edit }
          format.json { render json: @membership.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :edit }
        format.json { render json: {name: 'already used'}, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @membership.update_attributes(membership_params)
        format.html {
          flash[:success] = "membership updated successfully"
          redirect_to facility_memberships_path
        }
        format.json { render json: @membership, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit
  end

  def destroy
    @membership.destroy
    respond_to do |format|
      flash[:success] = "membership was successfully deleted."
      format.html { redirect_to facility_memberships_path }
      format.json { head :no_content }
    end
  end


  private
  def set_facility
    @facility = Facility.find(facility_id)
  end

  def facility_id
    current_owner.facility.id
  end

  private
  def set_membership
    @membership = Membership.where({id:params[:id],facility_id: facility_id}).first
  end

  def membership_params
    params.require(:membership).permit([:name, :duration, :duration_type, :cost, :temporary])
  end


end

