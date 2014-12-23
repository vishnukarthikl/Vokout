class SessionsController < ApplicationController
  def new
  end

  def create
    owner = Owner.find_by(email: params[:session][:email].downcase)
    if owner && owner.authenticate(params[:session][:password])
      log_in owner
      redirect_to dashboard_owner_path(owner)
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
      log_out
      flash[:success] = 'Logout successful'
      redirect_to root_url
  end
end
