class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def root
    if logged_in?
      redirect_to dashboard_path
    elsif admin_signed_in?
      redirect_to admin_dashboard_path
    else
      redirect_to home_path
    end
  end

  def authenticate
    unless logged_in?
      #todo: get current url and redirect after login
      redirect_to login_path
    end
    if logged_in?
      @owner = current_owner
      if @owner.deactivated
        render 'owners/deactivated'
      elsif !current_owner.confirmed?
        render 'owners/unconfirmed'
      end
    end
  end

  def check_collaborator
   if logged_in? and current_owner.is_collaborator
     redirect_to dashboard_members_path
   end
  end


end
