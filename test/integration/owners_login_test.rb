require 'test_helper'

class OwnersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @owner = owners(:owner1)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get signup_path
    assert flash.empty?
    assert_not is_logged_in?
  end

  test "login with valid information" do
    get login_path
    post login_path, session: { email: @owner.email, password: 'password' }
    assert_redirected_to dashboard_owner_path(@owner)
    follow_redirect!
    assert_template 'owners/dashboard'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    # assert_select "a[href=?]", owner_path(@owner)
  end
  
  test "after login root path should redirect to owner dashboard" do
    get login_path
    post login_path, session: { email: @owner.email, password: 'password' }
    get root_path
    follow_redirect!
    assert_template 'owners/dashboard'
  end

  test "without login root path should redirect to home" do
    get login_path
    assert_template 'sessions/new'
    get root_path
    follow_redirect!
    assert_template 'static/home'
  end
end
