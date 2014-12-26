ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def is_logged_in?
    !session[:owner_id].nil?
  end
  
  def login(owner,password)
    get login_path
    post login_path, session: { email: owner.email, password: password }
    assert_redirected_to dashboard_owner_path(owner)
    follow_redirect!
    assert_template 'owners/dashboard'
  end
end
