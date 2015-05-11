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
      if current_owner.deactivated
        redirect_to deactivated_owner_path
      elsif !current_owner.confirmed?
        redirect_to unconfirmed_owner_path(current_owner)
      end
    end
  end

end
