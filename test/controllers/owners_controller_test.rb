require 'test_helper'

class OwnersControllerTest < ActionController::TestCase
  # todo: use rspec, current test sucks

  # setup do
  #   @owner = facilities(:afterburn).owner
  # end
  #
  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:owners)
  # end
  #
  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end
  #
  # test "should create owner" do
  #   assert_difference('Owner.count') do
  #     post :create, owner: { email: "foo@bar.com", name: "owner name", password: "123456", password_confirmation: "123456" }
  #   end
  #
  #   assert_redirected_to dashboard_owner_path(assigns(:owner))
  # end
  #
  # test "should show owner" do
  #   get :show, id: @owner
  #   assert_response :success
  # end
  #
  # test "should get edit" do
  #   get :edit, id: @owner
  #   assert_response :success
  # end
  #
  # test "should update owner" do
  #   patch :update, id: @owner, owner: { email: "newemail@bar.com",password: "123456",password_confirmation: "123456" }
  #   assert_redirected_to owner_path(assigns(:owner))
  # end
  #
  # test "should destroy owner" do
  #   assert_difference('Owner.count', -1) do
  #     delete :destroy, id: @owner
  #   end
  #
  #   assert_redirected_to owners_path
  # end
  #
  # test "should return facility of owner" do
  #   get :dashboard, id: @owner
  #   assert_equal "Afterburn", assigns(:facility).name
  # end
end
