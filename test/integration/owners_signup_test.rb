require 'test_helper'

class OwnersSignupTest < ActionDispatch::IntegrationTest

  # test "invalid signup information" do
  #   get signup_path
  #   assert_no_difference 'Owner.count' do
  #     post owners_path, owner: { name:  "",
  #         email: "user@invalid",
  #         password:              "foo",
  #         password_confirmation: "bar" }
  #   end
  #   assert_template 'owners/new'
  # end
  #
  # test "valid signup information" do
  #   get signup_path
  #   assert_difference 'Owner.count', 1 do
  #     post_via_redirect owners_path, owner: { name:  "Example User",
  #         email: "user@example.com",
  #         password:              "password",
  #         password_confirmation: "password" }
  #   end
  #   assert_template 'owners/dashboard'
  #   assert_not flash.empty?
  # end

end
