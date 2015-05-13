class AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_owner, only: [:deactivate, :activate, :destroy, :edit, :update]

  def dashboard
    @owners = Owner.all.includes(:facility)
    @contact_messages = ContactMessage.all
  end

  def deactivate
    @owner.deactivated = true
    respond_to do |format|
      if @owner.save
        format.html {
          flash[:success] = "#{@owner.name} was deactivated"
          redirect_to :back
        }
        format.json { render :show, status: :ok, location: @owner }
      else
        format.html {
          flash[:danger] = "#{@owner.errors.as_json} was not deactivated"
          redirect_to :back
        }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  def activate
    @owner.deactivated = false
    respond_to do |format|
      if @owner.save
        format.html {
          flash[:success] = "#{@owner.name} was activated"
          redirect_to :back
        }
        format.json { render :show, status: :ok, location: @owner }
      else
        format.html {
          flash[:danger] = "#{@owner.name} was not activated"
          redirect_to :back
        }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @owner.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Owner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit

  end

  def update
    respond_to do |format|
      if @owner.update_attributes(owner_params)
        format.html {
          flash[:success] = "Profile updated successfully"
          redirect_to admin_dashboard_path
        }
        format.json { render :show, status: :ok, location: @owner }
      else
        format.html { render :edit }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_owner
    @owner = Owner.find(params[:id])
  end

  private
  def owner_params
    params.require(:owner).permit(:name, :password, :password_confirmation)
  end

end