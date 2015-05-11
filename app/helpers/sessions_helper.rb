module SessionsHelper
  def log_in(owner, remember_me)
    if remember_me == '1'
      cookies.permanent[:auth_token] = owner.auth_token
    else
      cookies[:auth_token] = owner.auth_token
    end
  end

  def current_owner
    @current_owner ||= Owner.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end

  def logged_in?
    !current_owner.nil?
  end

  def log_out
    cookies.delete(:auth_token)
    @current_owner = nil
  end

end
