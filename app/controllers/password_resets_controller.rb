class PasswordResetsController < ApplicationController
  def new
  end

  def create
    owner = Owner.find_by_email(params[:email])
    owner.send_password_reset if owner
    redirect_to root_url, :notice => "Email sent with password reset instructions"
  end

  def edit
    @owner = Owner.find_by_password_reset_token!(params[:id])
  end

  def update
    @owner = Owner.find_by_password_reset_token(params[:id])
    if @owner.password_reset_sent_at < 2.hours.ago
      puts "expired"
      redirect_to new_password_reset_path, :alert => "Password reset has expired"
    elsif @owner.update_attributes(owner_params)
      redirect_to sessions_new_path, :notice => "Password has been reset"
    else
      render :edit
    end

  end

  def owner_params
    params.require(:owner).permit([:password, :password_confirmation])
  end
end
