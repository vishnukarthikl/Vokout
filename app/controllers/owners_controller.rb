class OwnersController < ApplicationController
  before_filter :authenticate, only: [:show, :edit, :update, :unconfirmed, :deactivated]
  before_filter :check_collaborator, except: [:create_collaborator, :confirm_collaborator, :collaborator_password, :unconfirmed]

  before_action :set_owner, only: [:show, :edit, :update]

  before_action :set_owner_from_param, only: :collaborator_password

  def show
  end

  def new_collaborator
    if !current_owner.facility
      redirect_to current_owner_path
    end
    @owner = Owner.new
  end

  def create_collaborator
    @owner = Owner.new(collaborator_params)
    @owner.is_collaborator = true
    @owner.password = SecureRandom.urlsafe_base64
    @owner.facility = current_owner.facility
    if @owner.save
      flash[:success] = "#{@owner.name}, has been added as a collaborator"
      redirect_to current_owner_path
    else
      render :new_collaborator
    end
  end

  def new
    @owner = Owner.new
  end

  def edit
  end

  def create
    @owner = Owner.new(owner_params)

    respond_to do |format|
      if @owner.save
        format.html {
          log_in(@owner, true)
          flash[:success] = "#{@owner.name}, your profile has been created"
          redirect_to dashboard_path
        }
        format.json { render :show, status: :created, location: @owner }
      else
        format.html { render :new }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @owner.update_attributes(owner_update_params) && @owner.facility.update_attributes(facility_update_params)
        format.html {
          flash[:success] = "Profile updated successfully"
          redirect_to current_owner_path
        }
        format.json { render :show, status: :ok, location: @owner }
      else
        format.html { render :edit }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm
    @owner = Owner.find_by_confirmation_code(params[:code])
    if @owner
      @owner.confirm
      flash[:success] = "Your account has been successfully verified"
      redirect_to dashboard_path
    else
      flash[:notice] = "Account verified failed"
      redirect_to root_url
    end
  end

  def confirm_collaborator
    @owner = Owner.find_by_confirmation_code(params[:code])
    if @owner.confirmed
      redirect_to dashboard_path
    end
  end

  def collaborator_password
    validate_password
    if @owner.errors.any?
      render :confirm_collaborator
    elsif @owner.update_attributes(collaborator_password_param)
      @owner.confirmed = true
      @owner.save
      flash[:success] = "Your account has been successfully created"
      redirect_to dashboard_path
    else
      render :confirm_collaborator
    end

  end

  def validate_password
    if collaborator_password_param[:password].empty?
      @owner.errors.add(:password, "Can't be blank")
    end
    if collaborator_password_param[:password_confirmation].empty?
      @owner.errors.add(:password_confirmation, "Can't be blank")
    end
  end

  def unconfirmed

  end

  def deactivated

  end

  private
  def set_owner_from_param
    @owner = Owner.find(params[:id])
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_owner
    @owner = current_owner
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def owner_params
    params.require(:owner).permit(:name, :email, :password, :password_confirmation)
  end

  def owner_update_params
    params.require(:owner).permit(:name, :password, :password_confirmation)
  end

  def facility_update_params
    params.require(:owner).require(:facility).permit(:name, :phone, :address)
  end

  def collaborator_params
    params.require(:owner).permit(:name, :email)
  end

  def collaborator_password_param
    params.require(:owner).permit(:password, :password_confirmation)
  end

end
