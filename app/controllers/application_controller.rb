class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  def root
    if logged_in?
      redirect_to dashboard_path
    else
      redirect_to home_path
    end
  end

  def authenticate
    unless logged_in?
      #todo: get current url and redirect after login
      redirect_to 'SessionsController#new'
    end
  end

end
