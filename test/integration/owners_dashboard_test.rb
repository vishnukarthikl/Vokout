require 'test_helper'

class OwnersDashboardTest < ActionDispatch::IntegrationTest
  def setup
    @owner = owners(:owner1)
    @owner_with_facility = facilities(:afterburn).owner
  end
  
  test "should ask to add facility if not added" do
    login(@owner,'password')
    assert_select "div[id='dashboard'] h1", 'Initial Setup'
  end
  
  test "should show facility name if added" do
    login(@owner_with_facility,'password')
    assert_select "div[id='dashboard'] h1", @owner_with_facility.facility.name
  end
  
end
