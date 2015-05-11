class OwnersController < ApplicationController
  before_filter :authenticate, unless: [:new]

  before_action :set_owner, only: [:show, :edit, :update, :destroy,:deactivate,:activate,:unconfirmed]

  respond_to :json

  # GET /owners
  # GET /owners.json
  def index
    @owners = Owner.all
  end

  # GET /owners/1
  # GET /owners/1.json
  def show
    true
  end

  # GET /owners/new
  def new
    @owner = Owner.new
  end

  # GET /owners/1/edit
  def edit
  end

  # POST /owners
  # POST /owners.json
  def create
    @owner = Owner.new(owner_params)

    respond_to do |format|
      if @owner.save
        format.html {
          log_in(@owner, true)
          flash[:success] = "#{@owner.name}, your profile has been created"
          redirect_to dashboard_path(@owner)
        }
        format.json { render :show, status: :created, location: @owner }
      else
        format.html { render :new }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /owners/1
  # PATCH/PUT /owners/1.json
  def update
    respond_to do |format|
      if @owner.update_attributes(owner_params)
        format.html {
          flash[:success] = "Profile updated successfully"
          redirect_to @owner
        }
        format.json { render :show, status: :ok, location: @owner }
      else
        format.html { render :edit }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
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

  def unconfirmed

  end

  def deactivated

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


  # DELETE /owners/1
  # DELETE /owners/1.json
  def destroy
    @owner.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Owner was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_owner
    @owner = Owner.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def owner_params
    params.require(:owner).permit(:name, :email, :password, :password_confirmation)
  end
end
